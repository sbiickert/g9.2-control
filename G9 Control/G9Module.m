//
//  G9Module.m
//  G9 Control
//
//  Created by Simon Biickert on 1/4/2014.
//  Copyright (c) 2014 Simon Biickert. All rights reserved.
//

#import "G9Module.h"
#import "G9Patch+Access.h"

@implementation G9Module

@synthesize moduleName = _moduleName;
@synthesize patch = _patch;

-(id) initWithModuleName:(NSString *)name patch:(G9Patch *)patch
{
	self = [super init];
	
	if (self)
	{
		self.moduleName = name;
		self.patch = patch;
	}
	
	return self;
}

- (G9Setting *)setting
{
	return [self.patch settingForName:self.moduleName];
}

+ (NSSet *) keyPathsForValuesAffectingValueForKey:(NSString *)key
{
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"setting"])
	{
		NSArray *affectingKeys = @[@"patch.ampSelection"];
		keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
	}
	
	return keyPaths;
}

@end
