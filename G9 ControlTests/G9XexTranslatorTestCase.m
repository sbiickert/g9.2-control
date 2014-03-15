		//
//  G9XexTranslatorTestCase.m
//  G9 Control
//
//  Created by Simon Biickert on 12/13/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "G9XexTranslator.h"
#import "G9PatchSet+Access.h"
#import "G9Patch.h"

@interface G9XexTranslatorTestCase : XCTestCase

@end

@implementation G9XexTranslatorTestCase

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
//	G9PatchSet *patchSet = [G9XexTranslator loadDefaultPatchesIntoManagedObjectContext:context];
//    XCTAssertNotNil(patchSet, @"Parsing the XML resulted in nil returned.");
//	
//	for (NSString *label in @[ @"A", @"b", @"U", @"u" ]) {
//		G9Group *group = [patchSet groupWithLabel:label];
//		for (NSUInteger i = 0; i < 10; i++) {
//			G9Bank *bank = [group bankAtIndex:i];
//			G9Patch *patch;
//			patch = (G9Patch *)bank.patch1;
//			XCTAssertNotNil(patch, @"Null patch 1 in Bank %@-%@",group.label, bank.bankIndex);
//			patch = (G9Patch *)bank.patch2;
//			XCTAssertNotNil(patch, @"Null patch 2 in Bank %@-%@",group.label, bank.bankIndex);
//			patch = (G9Patch *)bank.patch3;
//			XCTAssertNotNil(patch, @"Null patch 3 in Bank %@-%@",group.label, bank.bankIndex);
//			patch = (G9Patch *)bank.patch4;
//			XCTAssertNotNil(patch, @"Null patch 4 in Bank %@-%@",group.label, bank.bankIndex);
//			patch = (G9Patch *)bank.patch5;
//			XCTAssertNotNil(patch, @"Null patch 5 in Bank %@-%@",group.label, bank.bankIndex);
//		}
//	}
//	
//	[G9XexTranslator savePatchSetAtDefaultLocation:patchSet];
}

@end
