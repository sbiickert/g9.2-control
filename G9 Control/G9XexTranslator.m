//
//  G9XexTranslator.m
//  G9 Control
//
//  Created by Simon Biickert on 12/13/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import "G9XexTranslator.h"
//#import "G9AppDelegate.h"
#import "G9ParameterInfo.h"

#import "G9PatchSet+Access.h"
#import "G9Patch+Access.h"
#import "G9Setting.h"

#import "GDataXMLNode.h"

@implementation G9XexTranslator

+ (NSArray *) documentNamespaces
{
	static NSArray *ns;
	if (!ns) {
		ns = @[ [GDataXMLNode namespaceWithName:@"xsi" stringValue:@"http://www.w3.org/2001/XMLSchema-instance"],
				[GDataXMLNode namespaceWithName:@"xsd" stringValue:@"http://www.w3.org/2001/XMLSchema"] ];
	}
	return ns;
}

+ (NSString *)dataFilePath:(BOOL)forSave
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = paths[0];
	NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:@"Test.xex"];
	
	if (forSave) // || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath])
	{
		return documentsPath;
	}
	else
	{
		return [[NSBundle mainBundle] pathForResource:@"FactoryPatches" ofType:@"xml"];
	}
}

+ (G9PatchSet *) loadDefaultPatchesIntoManagedObjectContext:(NSManagedObjectContext *)context
{
	NSString *filePath = [self dataFilePath:NO];
	return [G9XexTranslator loadXexFileAtPath:filePath
					 intoManagedObjectContext:context
									 withName:@"Factory"];
}

+ (G9PatchSet *) loadXexFileAtPath:(NSString *)filePath
		  intoManagedObjectContext:(NSManagedObjectContext *)context
						  withName:(NSString *)name
{
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
														   options:0 error:&error];
    if (doc == nil) { return nil; }
		
	G9PatchSet *patchSet = [G9PatchSet createPatchSetWithName:name
									   inManagedObjectContext:context];
	
	NSArray *patches = [doc nodesForXPath:@"//G9ED_PatchSet/Factory/ArrayOfAnyType/anyType"
									error:&error];

    if (patches == nil) { return nil; }
	
	NSUInteger xmlPatchIndex = 0;
	for (NSString *groupLabel in @[@"U", @"u"]) {
		for (NSInteger bankIndex = 0; bankIndex < 10; bankIndex++)
		{
			for (NSInteger patchIndex = 1; patchIndex <= 5; patchIndex++)
			{
				G9Patch *patch = [G9XexTranslator patchFromXML:[patches objectAtIndex:xmlPatchIndex++]
													 withGroup:groupLabel
														  bank:[NSNumber numberWithInteger:bankIndex]
													patchIndex:[NSNumber numberWithInteger:patchIndex]
										inManagedObjectContext:context];
				[patchSet addPatchesObject:patch];
			}
		}
	}
	
	return patchSet;
}

+ (G9Patch *) patchFromXML:(GDataXMLElement *)patchXML
				 withGroup:(NSString *)group
					  bank:(NSNumber *)bank
				patchIndex:(NSNumber *)patchIndex
	inManagedObjectContext:(NSManagedObjectContext *)context
{
	if (!patchXML) {
		return nil;
	}
	
	G9Patch *patch = [G9Patch createPatchWithGroup:group
											  bank:bank
										patchIndex:patchIndex
							inManagedObjectContext:context];
	
	GDataXMLElement *element;
	
	element = [G9XexTranslator singleElementForName:@"Name" fromXMLElement:patchXML];
	patch.name = element.stringValue;
	
	element = [G9XexTranslator singleElementForName:@"Comment" fromXMLElement:patchXML];
	patch.comment = element.stringValue;
	
	element = [G9XexTranslator singleElementForName:@"PatchLevel" fromXMLElement:patchXML];
	patch.patchLevel = [G9XexTranslator numberValueFromXML:element];
	
	element = [G9XexTranslator singleElementForName:@"AmpSel" fromXMLElement:patchXML];
	patch.ampSelection = [G9XexTranslator numberValueFromXML:element];
	
	// "Total"
	G9Setting *totalSetting = [[G9Setting alloc] init];
	element = [G9XexTranslator singleElementForName:@"Tempo" fromXMLElement:patchXML];
	totalSetting.param1 = [[G9XexTranslator numberValueFromXML:element] unsignedIntegerValue];
	
	element = [G9XexTranslator singleElementForName:@"PedalFunction" fromXMLElement:patchXML];
	NSArray *pedalFuncElements = [element elementsForName:@"int"];
	totalSetting.param2 = [[G9XexTranslator numberValueFromXML:pedalFuncElements[0]] integerValue];
	totalSetting.param3 = [[G9XexTranslator numberValueFromXML:pedalFuncElements[1]] integerValue];
	
	patch.total = totalSetting;
	
	// Modules
	element = [G9XexTranslator singleElementForName:@"AmpA" fromXMLElement:patchXML];
	patch.ampA = [G9XexTranslator settingFromXML:element];
	
	element = [G9XexTranslator singleElementForName:@"AmpB" fromXMLElement:patchXML];
	patch.ampB = [G9XexTranslator settingFromXML:element];
	
	element = [G9XexTranslator singleElementForName:@"ZnrA" fromXMLElement:patchXML];
	patch.znrA = [G9XexTranslator settingFromXML:element];
	
	element = [G9XexTranslator singleElementForName:@"ZnrB" fromXMLElement:patchXML];
	patch.znrB = [G9XexTranslator settingFromXML:element];
	
	element = [G9XexTranslator singleElementForName:@"EqA" fromXMLElement:patchXML];
	patch.eqA = [G9XexTranslator settingFromXML:element];
	
	element = [G9XexTranslator singleElementForName:@"EqB" fromXMLElement:patchXML];
	patch.eqB = [G9XexTranslator settingFromXML:element];
	
	// the eq values are offset by 12 to make them positive in the XML. Correct it.
	((G9Setting *)patch.eqA).param1 -= 12;
	((G9Setting *)patch.eqA).param2 -= 12;
	((G9Setting *)patch.eqA).param3 -= 12;
	((G9Setting *)patch.eqA).param4 -= 12;
	((G9Setting *)patch.eqA).param5 -= 12;
	((G9Setting *)patch.eqA).param6 -= 12;
	((G9Setting *)patch.eqB).param1 -= 12;
	((G9Setting *)patch.eqB).param2 -= 12;
	((G9Setting *)patch.eqB).param3 -= 12;
	((G9Setting *)patch.eqB).param4 -= 12;
	((G9Setting *)patch.eqB).param5 -= 12;
	((G9Setting *)patch.eqB).param6 -= 12;
	
	element = [G9XexTranslator singleElementForName:@"Ext" fromXMLElement:patchXML];
	patch.extLoop = [G9XexTranslator settingFromXML:element];
	
	element = [G9XexTranslator singleElementForName:@"Cabi" fromXMLElement:patchXML];
	patch.cab = [G9XexTranslator settingFromXML:element];
	
	element = [G9XexTranslator singleElementForName:@"Comp" fromXMLElement:patchXML];
	patch.comp = [G9XexTranslator settingFromXML:element];
	
	element = [G9XexTranslator singleElementForName:@"Wah" fromXMLElement:patchXML];
	patch.wah = [G9XexTranslator settingFromXML:element];
	
	element = [G9XexTranslator singleElementForName:@"Modulation" fromXMLElement:patchXML];
	patch.mod = [G9XexTranslator settingFromXML:element];
	
	element = [G9XexTranslator singleElementForName:@"Delay" fromXMLElement:patchXML];
	patch.delay = [G9XexTranslator settingFromXML:element];
	
	element = [G9XexTranslator singleElementForName:@"Reverb" fromXMLElement:patchXML];
	patch.reverb = [G9XexTranslator settingFromXML:element];
	
	element = [G9XexTranslator singleElementForName:@"Arrm" fromXMLElement:patchXML];
	patch.arrm = [G9XexTranslator arrmSettingFromXML:element];

	// Pedals
	NSArray *pedalParamElements;
	
	GDataXMLElement *pedal1Element = [G9XexTranslator singleElementForName:@"Pedal1" fromXMLElement:patchXML];
	pedalParamElements = [pedal1Element elementsForName:@"PedalParm"];
	patch.pedal1v1 = [G9XexTranslator pedalSettingFromXML:pedalParamElements[0]];
	patch.pedal1v2 = [G9XexTranslator pedalSettingFromXML:pedalParamElements[1]];
	patch.pedal1v3 = [G9XexTranslator pedalSettingFromXML:pedalParamElements[2]];
	patch.pedal1v4 = [G9XexTranslator pedalSettingFromXML:pedalParamElements[3]];
	
	GDataXMLElement *pedal2VElement = [G9XexTranslator singleElementForName:@"Pedal2V" fromXMLElement:patchXML];
	pedalParamElements = [pedal2VElement elementsForName:@"PedalParm"];
	patch.pedal2v1 = [G9XexTranslator pedalSettingFromXML:pedalParamElements[0]];
	patch.pedal2v2 = [G9XexTranslator pedalSettingFromXML:pedalParamElements[1]];
	patch.pedal2v3 = [G9XexTranslator pedalSettingFromXML:pedalParamElements[2]];
	patch.pedal2v4 = [G9XexTranslator pedalSettingFromXML:pedalParamElements[3]];
	
	GDataXMLElement *pedal2HElement = [G9XexTranslator singleElementForName:@"Pedal2H" fromXMLElement:patchXML];
	pedalParamElements = [pedal2HElement elementsForName:@"PedalParm"];
	patch.pedal2h1 = [G9XexTranslator pedalSettingFromXML:pedalParamElements[0]];
	patch.pedal2h2 = [G9XexTranslator pedalSettingFromXML:pedalParamElements[1]];
	patch.pedal2h3 = [G9XexTranslator pedalSettingFromXML:pedalParamElements[2]];
	patch.pedal2h4 = [G9XexTranslator pedalSettingFromXML:pedalParamElements[3]];
	
	return patch;
}

+ (GDataXMLElement *) singleElementForName:(NSString *)name
							fromXMLElement:(GDataXMLElement *)xml
{
	NSArray *elements;
	elements = [xml elementsForName:name];
	if (elements.count > 0) {
		return elements[0];
	}
	return nil;
}

+ (NSNumber *) numberValueFromXML:(GDataXMLElement *) xml
{
	static NSNumberFormatter *formatter;
	if (!formatter) {
		formatter = [[NSNumberFormatter alloc] init];
		formatter.numberStyle = NSNumberFormatterDecimalStyle;
	}
	
	NSNumber *value = nil;
	
	if (xml) {
		value = [formatter numberFromString:xml.stringValue];
	}
	
	return value;
}

+ (BOOL) booleanValueFromXML:(GDataXMLElement *) xml
{
	BOOL value = NO;
	
	value = [xml.stringValue isEqualToString:@"true"];
	
	return value;
}

+ (G9Setting *) settingFromXML:(GDataXMLElement *)settingXML
{
	G9Setting *setting = [[G9Setting alloc] init];
	
	GDataXMLElement *element;

	element = [G9XexTranslator singleElementForName:@"onoff" fromXMLElement:settingXML];
	setting.enabled = [G9XexTranslator booleanValueFromXML:element];
	
	element = [G9XexTranslator singleElementForName:@"type" fromXMLElement:settingXML];
	setting.type = [[G9XexTranslator numberValueFromXML:element] unsignedIntegerValue];
	
	element = [G9XexTranslator singleElementForName:@"parm1" fromXMLElement:settingXML];
	setting.param1 = [[G9XexTranslator numberValueFromXML:element] integerValue];
	
	element = [G9XexTranslator singleElementForName:@"parm2" fromXMLElement:settingXML];
	setting.param2 = [[G9XexTranslator numberValueFromXML:element] integerValue];
	
	element = [G9XexTranslator singleElementForName:@"parm3" fromXMLElement:settingXML];
	setting.param3 = [[G9XexTranslator numberValueFromXML:element] integerValue];
	
	element = [G9XexTranslator singleElementForName:@"parm4" fromXMLElement:settingXML];
	setting.param4 = [[G9XexTranslator numberValueFromXML:element] integerValue];
	
	element = [G9XexTranslator singleElementForName:@"parm5" fromXMLElement:settingXML];
	setting.param5 = [[G9XexTranslator numberValueFromXML:element] integerValue];
	
	element = [G9XexTranslator singleElementForName:@"parm6" fromXMLElement:settingXML];
	setting.param6 = [[G9XexTranslator numberValueFromXML:element] integerValue];
	
	return setting;
}

+ (G9Setting *)arrmSettingFromXML:(GDataXMLElement *)arrmSettingXML
{
	G9Setting *setting = [[G9Setting alloc] init];
	
	GDataXMLElement *element;
	
	element = [G9XexTranslator singleElementForName:@"target" fromXMLElement:arrmSettingXML];
	setting.param1 = [[G9XexTranslator numberValueFromXML:element] integerValue];
	
	element = [G9XexTranslator singleElementForName:@"min" fromXMLElement:arrmSettingXML];
	setting.param2 = [[G9XexTranslator numberValueFromXML:element] integerValue];
	
	element = [G9XexTranslator singleElementForName:@"max" fromXMLElement:arrmSettingXML];
	setting.param3 = [[G9XexTranslator numberValueFromXML:element] integerValue];
	
	element = [G9XexTranslator singleElementForName:@"wave" fromXMLElement:arrmSettingXML];
	setting.param4 = [[G9XexTranslator numberValueFromXML:element] integerValue];
	
	element = [G9XexTranslator singleElementForName:@"sync" fromXMLElement:arrmSettingXML];
	setting.param5 = [[G9XexTranslator numberValueFromXML:element] integerValue];

	return setting;
}

+ (G9Setting *) pedalSettingFromXML:(GDataXMLElement *)pedalSettingXML
{
	G9Setting *setting = [[G9Setting alloc] init];
	
	GDataXMLElement *element;
	
	element = [G9XexTranslator singleElementForName:@"assign" fromXMLElement:pedalSettingXML];
	setting.param1 = [[G9XexTranslator numberValueFromXML:element] integerValue];
	
	element = [G9XexTranslator singleElementForName:@"min" fromXMLElement:pedalSettingXML];
	setting.param2 = [[G9XexTranslator numberValueFromXML:element] integerValue];
	
	element = [G9XexTranslator singleElementForName:@"max" fromXMLElement:pedalSettingXML];
	setting.param3 = [[G9XexTranslator numberValueFromXML:element] integerValue];
	
	// onoff is parameter 4, the pedal switch function on/off
	element = [G9XexTranslator singleElementForName:@"onoff" fromXMLElement:pedalSettingXML];
	setting.param4 = [[NSNumber numberWithBool:[G9XexTranslator booleanValueFromXML:element]] integerValue];
	
	return setting;
}

#pragma mark Export to XML

+ (void) savePatchSetAtDefaultLocation:(G9PatchSet *)patchSet
{
	[G9XexTranslator savePatchSet:patchSet toFileAtPath:[G9XexTranslator dataFilePath:YES]];
}

+ (void) savePatchSet:(G9PatchSet *)patchSet
		 toFileAtPath:(NSString *)filePath
{
	// Create element tree here.
	GDataXMLElement *root = [GDataXMLNode elementWithName:@"G9ED_PatchSet"];
	GDataXMLElement *factory = [GDataXMLNode elementWithName:@"Factory"];
	GDataXMLElement *arrayElement = [GDataXMLNode elementWithName:@"ArrayOfAnyType"];
	arrayElement.namespaces = [G9XexTranslator documentNamespaces];
	
	// Loop through patches
	for (NSString *groupLabel in @[@"U", @"u"]) {
		for (NSInteger bankIndex = 0; bankIndex < 10; bankIndex++)
		{
			for (NSInteger patchIndex = 1; patchIndex <= 5; patchIndex++)
			{
				G9Patch *patch = [patchSet patchForGroup:groupLabel
													bankIndex:[NSNumber numberWithInteger:bankIndex]
											  patchIndex:[NSNumber numberWithInteger:patchIndex]];

				GDataXMLElement *patchElement;
				
				patchElement = [G9XexTranslator xmlElementForPatch:patch];
				[arrayElement addChild:patchElement];
			}
		}
	}
	
	[factory addChild:arrayElement];
	[root addChild:factory];
	
	GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:root];
	NSData *xmlData = document.XMLData;
	
	NSLog(@"Saving XEX data to '%@'", filePath);
	
	[xmlData writeToFile:filePath atomically:YES];
}

+ (GDataXMLElement *) xmlElementForPatch:(G9Patch *)patch
{
	GDataXMLElement *patchElement = [GDataXMLNode elementWithName:@"anyType"];
	patchElement.namespaces = [G9XexTranslator documentNamespaces];
	
	GDataXMLNode *attrNode = [GDataXMLNode attributeWithName:@"xsi:type" stringValue:@"Patch"];
	[patchElement addAttribute:attrNode];
	
	GDataXMLNode *childNode;
	
	childNode = [GDataXMLNode elementWithName:@"PatchLevel" stringValue:[patch.patchLevel stringValue]];
	[patchElement addChild:childNode];
	
	childNode = [GDataXMLNode elementWithName:@"AmpSel" stringValue:[patch.ampSelection stringValue]];
	[patchElement addChild:childNode];
	
	G9Setting *totalSetting = patch.total;
	childNode = [GDataXMLNode elementWithName:@"Tempo" stringValue:[@(totalSetting.param1) stringValue]];
	[patchElement addChild:childNode];

	GDataXMLElement *pedalFuncElement = [GDataXMLNode elementWithName:@"PedalFunction"];
	childNode = [GDataXMLNode elementWithName:@"int" stringValue:[@(totalSetting.param2) stringValue]];
	[pedalFuncElement addChild:childNode];
	childNode = [GDataXMLNode elementWithName:@"int" stringValue:[@(totalSetting.param3) stringValue]];
	[pedalFuncElement addChild:childNode];
	[patchElement addChild:pedalFuncElement];
	
	childNode = [G9XexTranslator xmlElementForSetting:patch.ampA inModuleNamed:[NSString stringWithFormat:@"%@A", MODULE_AMP] withXMLElementName:@"AmpA"];
	[patchElement addChild:childNode];
	
	childNode = [G9XexTranslator xmlElementForSetting:patch.ampB inModuleNamed:[NSString stringWithFormat:@"%@B", MODULE_AMP] withXMLElementName:@"AmpB"];
	[patchElement addChild:childNode];
	
	childNode = [G9XexTranslator xmlElementForSetting:patch.znrA inModuleNamed:[NSString stringWithFormat:@"%@A", MODULE_ZNR] withXMLElementName:@"ZnrA"];
	[patchElement addChild:childNode];
	
	childNode = [G9XexTranslator xmlElementForSetting:patch.znrB inModuleNamed:[NSString stringWithFormat:@"%@B", MODULE_ZNR] withXMLElementName:@"ZnrB"];
	[patchElement addChild:childNode];
	
	// the eq values are offset by 12 to make them positive in the XML. Correct it.
	G9Setting *eqA = [[G9Setting alloc] init];
	[((G9Setting *)patch.eqA) copyValuesTo:eqA];
	eqA.param1 += 12;
	eqA.param2 += 12;
	eqA.param3 += 12;
	eqA.param4 += 12;
	eqA.param5 += 12;
	eqA.param6 += 12;
	G9Setting *eqB = [[G9Setting alloc] init];
	[((G9Setting *)patch.eqB) copyValuesTo:eqB];
	eqB.param1 += 12;
	eqB.param2 += 12;
	eqB.param3 += 12;
	eqB.param4 += 12;
	eqB.param5 += 12;
	eqB.param6 += 12;
	
	childNode = [G9XexTranslator xmlElementForSetting:eqA inModuleNamed:[NSString stringWithFormat:@"%@A", MODULE_EQ] withXMLElementName:@"EqA"];
	[patchElement addChild:childNode];
	
	childNode = [G9XexTranslator xmlElementForSetting:eqB inModuleNamed:[NSString stringWithFormat:@"%@B", MODULE_EQ] withXMLElementName:@"EqB"];
	[patchElement addChild:childNode];
	
	childNode = [G9XexTranslator xmlElementForSetting:patch.extLoop inModuleNamed:MODULE_EXTLOOP withXMLElementName:@"Ext"];
	[patchElement addChild:childNode];
	
	childNode = [G9XexTranslator xmlElementForSetting:patch.cab inModuleNamed:MODULE_CAB withXMLElementName:@"Cabi"];
	[patchElement addChild:childNode];
	
	childNode = [G9XexTranslator xmlElementForSetting:patch.comp inModuleNamed:MODULE_COMP withXMLElementName:@"Comp"];
	[patchElement addChild:childNode];
	
	childNode = [G9XexTranslator xmlElementForSetting:patch.wah inModuleNamed:MODULE_WAH withXMLElementName:@"Wah"];
	[patchElement addChild:childNode];
	
	childNode = [G9XexTranslator xmlElementForSetting:patch.mod inModuleNamed:MODULE_MOD withXMLElementName:@"Modulation"];
	[patchElement addChild:childNode];
	
	childNode = [G9XexTranslator xmlElementForSetting:patch.delay inModuleNamed:MODULE_DELAY withXMLElementName:@"Delay"];
	[patchElement addChild:childNode];
	
	childNode = [G9XexTranslator xmlElementForSetting:patch.reverb inModuleNamed:MODULE_REVERB withXMLElementName:@"Reverb"];
	[patchElement addChild:childNode];
	
	childNode = [G9XexTranslator xmlElementForArrmSetting:patch.arrm];
	[patchElement addChild:childNode];
	
	GDataXMLElement *pedalElement;
	
	pedalElement = [GDataXMLNode elementWithName:@"Pedal1"];
	childNode = [G9XexTranslator xmlElementForPedalSetting:patch.pedal1v1 forPedalNamed:@"Pedal1"];
	[pedalElement addChild:childNode];
	childNode = [G9XexTranslator xmlElementForPedalSetting:patch.pedal1v2 forPedalNamed:@"Pedal1"];
	[pedalElement addChild:childNode];
	childNode = [G9XexTranslator xmlElementForPedalSetting:patch.pedal1v3 forPedalNamed:@"Pedal1"];
	[pedalElement addChild:childNode];
	childNode = [G9XexTranslator xmlElementForPedalSetting:patch.pedal1v4 forPedalNamed:@"Pedal1"];
	[pedalElement addChild:childNode];
	[patchElement addChild:pedalElement];
	
	pedalElement = [GDataXMLNode elementWithName:@"Pedal2V"];
	childNode = [G9XexTranslator xmlElementForPedalSetting:patch.pedal2v1 forPedalNamed:@"Pedal2V"];
	[pedalElement addChild:childNode];
	childNode = [G9XexTranslator xmlElementForPedalSetting:patch.pedal2v2 forPedalNamed:@"Pedal2V"];
	[pedalElement addChild:childNode];
	childNode = [G9XexTranslator xmlElementForPedalSetting:patch.pedal2v3 forPedalNamed:@"Pedal2V"];
	[pedalElement addChild:childNode];
	childNode = [G9XexTranslator xmlElementForPedalSetting:patch.pedal2v4 forPedalNamed:@"Pedal2V"];
	[pedalElement addChild:childNode];
	[patchElement addChild:pedalElement];
	
	pedalElement = [GDataXMLNode elementWithName:@"Pedal2H"];
	childNode = [G9XexTranslator xmlElementForPedalSetting:patch.pedal2h1 forPedalNamed:@"Pedal2H"];
	[pedalElement addChild:childNode];
	childNode = [G9XexTranslator xmlElementForPedalSetting:patch.pedal2h2 forPedalNamed:@"Pedal2H"];
	[pedalElement addChild:childNode];
	childNode = [G9XexTranslator xmlElementForPedalSetting:patch.pedal2h3 forPedalNamed:@"Pedal2H"];
	[pedalElement addChild:childNode];
	childNode = [G9XexTranslator xmlElementForPedalSetting:patch.pedal2h4 forPedalNamed:@"Pedal2H"];
	[pedalElement addChild:childNode];
	[patchElement addChild:pedalElement];
	
	childNode = [GDataXMLNode elementWithName:@"Name" stringValue:patch.name];
	[patchElement addChild:childNode];
	
	childNode = [GDataXMLNode elementWithName:@"Comment" stringValue:patch.comment];
	[patchElement addChild:childNode];
	
	return patchElement;
}

+ (GDataXMLElement *) xmlElementForSetting:(G9Setting *)setting
							 inModuleNamed:(NSString *)moduleName
						withXMLElementName:(NSString *)elementName
{
	GDataXMLElement *moduleElement = [GDataXMLNode elementWithName:elementName];
	GDataXMLElement *childNode;
	
	childNode = [GDataXMLNode elementWithName:@"onoff" stringValue:(setting.enabled ? @"true" : @"false")];
	[moduleElement addChild:childNode];
	
	NSArray *elementsWithoutType = @[ @"EqA", @"EqB", @"Ext", @"Cabi"];
	if (![elementsWithoutType containsObject:elementName])
	{
		childNode = [GDataXMLNode elementWithName:@"type" stringValue:[@(setting.type) stringValue]];
		[moduleElement addChild:childNode];
	}
	
	NSUInteger paramCount = [G9ParameterInfo parameterCountForModuleNamed:moduleName];
	if (paramCount >= 1) {
		childNode = [GDataXMLNode elementWithName:@"parm1" stringValue:[@(setting.param1) stringValue]];
		[moduleElement addChild:childNode];
	}
	if (paramCount >= 2) {
		childNode = [GDataXMLNode elementWithName:@"parm2" stringValue:[@(setting.param2) stringValue]];
		[moduleElement addChild:childNode];
	}
	if (paramCount >= 3) {
		childNode = [GDataXMLNode elementWithName:@"parm3" stringValue:[@(setting.param3) stringValue]];
		[moduleElement addChild:childNode];
	}
	if (paramCount >= 4) {
		childNode = [GDataXMLNode elementWithName:@"parm4" stringValue:[@(setting.param4) stringValue]];
		[moduleElement addChild:childNode];
	}
	if (paramCount >= 5) {
		childNode = [GDataXMLNode elementWithName:@"parm5" stringValue:[@(setting.param5) stringValue]];
		[moduleElement addChild:childNode];
	}
	if (paramCount >= 6) {
		childNode = [GDataXMLNode elementWithName:@"parm6" stringValue:[@(setting.param6) stringValue]];
		[moduleElement addChild:childNode];
	}
	
	return moduleElement;
}

+ (GDataXMLElement *) xmlElementForPedalSetting:(G9Setting *)pedalSetting
								  forPedalNamed:(NSString *)pedalName
{
	GDataXMLElement *pedalParamElement = [GDataXMLNode elementWithName:@"PedalParm"];
	GDataXMLElement *childNode;
	
	childNode = [GDataXMLNode elementWithName:@"assign" stringValue:[@(pedalSetting.param1) stringValue]];
	[pedalParamElement addChild:childNode];
	
	childNode = [GDataXMLNode elementWithName:@"min" stringValue:[@(pedalSetting.param2) stringValue]];
	[pedalParamElement addChild:childNode];
	
	childNode = [GDataXMLNode elementWithName:@"max" stringValue:[@(pedalSetting.param3) stringValue]];
	[pedalParamElement addChild:childNode];
	
	childNode = [GDataXMLNode elementWithName:@"onoff" stringValue:(pedalSetting.param4 == 0 ? @"false" : @"true")];
	[pedalParamElement addChild:childNode];
	
	return pedalParamElement;
}

+ (GDataXMLElement *) xmlElementForArrmSetting:(G9Setting *)arrmSetting
{
	GDataXMLElement *arrmElement = [GDataXMLNode elementWithName:@"Arrm"];
	GDataXMLElement *childNode;
	
	childNode = [GDataXMLNode elementWithName:@"target" stringValue:[@(arrmSetting.param1) stringValue]];
	[arrmElement addChild:childNode];
	
	childNode = [GDataXMLNode elementWithName:@"min" stringValue:[@(arrmSetting.param2) stringValue]];
	[arrmElement addChild:childNode];
	
	childNode = [GDataXMLNode elementWithName:@"max" stringValue:[@(arrmSetting.param3) stringValue]];
	[arrmElement addChild:childNode];
	
	childNode = [GDataXMLNode elementWithName:@"wave" stringValue:[@(arrmSetting.param4) stringValue]];
	[arrmElement addChild:childNode];
	
	childNode = [GDataXMLNode elementWithName:@"sync" stringValue:[@(arrmSetting.param5) stringValue]];
	[arrmElement addChild:childNode];
	
	return arrmElement;
}

@end
