//
//  G9ParameterInfoTestCase.m
//  G9 Control
//
//  Created by Simon Biickert on 12/6/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "G9ParameterInfo.h"
#import "G9RangeDomain.h"

@interface G9ParameterInfoTestCase : XCTestCase

@end

@implementation G9ParameterInfoTestCase

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

- (void)testRange
{
    G9RangeDomain *range = [G9ParameterInfo rangeForParameter:4
													  forType:AMP_DZ_CRUNCH
													 inModule:MODULE_AMP];
	
	XCTAssertNotNil(range, @"Danger, danger!");
}

- (void)testName
{
	NSString *effectTypeName = [G9ParameterInfo nameForType:MOD_CHORUS
											  inModuleNamed:MODULE_MOD];
	
	XCTAssertTrue([effectTypeName isEqualToString:@"Chorus"], @"Tried to get name of Chorus module and got: %@", effectTypeName);
	
	NSString *parameterName = [G9ParameterInfo nameForParameter:4
														forType:REVERB_AUTOPAN
												  inModuleNamed:MODULE_REVERB];
	
	XCTAssertTrue([parameterName isEqualToString:@"Wave"], @"Param 4 of Auto Pan should be Wave, got: %@", parameterName);
	
	parameterName = [G9ParameterInfo nameForParameter:1
											  forType:AMP_DISTORTION_TYPES
										inModuleNamed:MODULE_AMP];
	
	XCTAssertTrue([parameterName isEqualToString:@"Gain"], @"Param 1 of amps should be Gain, got: %@", parameterName);
	
}

- (void)testDescription
{
	NSString *effectTypeDesc = [G9ParameterInfo descriptionForType:MOD_CHORUS
													 inModuleNamed:MODULE_MOD];
	
	XCTAssertNotNil(effectTypeDesc, @"Nil description for Chorus");
	NSLog(@"Chorus description: %@", effectTypeDesc);
	
	NSString *parameterDesc = [G9ParameterInfo descriptionForParameter:4
															   forType:REVERB_AUTOPAN
														 inModuleNamed:MODULE_REVERB];

	XCTAssertNotNil(effectTypeDesc, @"Nil description for Auto Pan param 4");
	NSLog(@"Auto pan param 4 description: %@", parameterDesc);
}

- (void)testControlTargets
{
	// This should be successful
	NSUInteger targetIndex = [G9ParameterInfo controlTargetIndexForParameter:1
																	 forType:AMP_DS_1
															   inModuleNamed:MODULE_AMP];
	
	XCTAssert(targetIndex > CONTROL_NOT_ASSIGNED && targetIndex <= CONTROL_MAX, @"Control target returned: %ld", targetIndex);
	
	// This should not
	NSUInteger badIndex = [G9ParameterInfo controlTargetIndexForParameter:3
																  forType:AMP_DS_1
															inModuleNamed:MODULE_AMP];
	
	XCTAssert(badIndex == CONTROL_NOT_ASSIGNED, @"Control target returned: %ld", badIndex);
	
	// Get the parameter range for the Gain on a distortion pedal
	G9RangeDomain *range = [G9ParameterInfo rangeForPedalWithControlTargetIndex:targetIndex];
	
	XCTAssertNotNil(range, @"Nil range returned for targetIndex %ld", targetIndex);
	XCTAssert(range.minimum == 0, @"Minimum gain should be zero, got: %ld", range.minimum);
	XCTAssert(range.maximum == 100, @"Maximum gain should be 100, got: %ld", range.maximum);
}

- (void)testDomains
{
	G9RangeDomain *range = [G9ParameterInfo rangeForParameter:4 forType:REVERB_PANDELAY inModule:MODULE_REVERB];
	
	XCTAssert([range isKindOfClass:[G9ValueDomain class]], @"range was not a value domain");
	
	G9ValueDomain *values = (G9ValueDomain *)range;
	XCTAssertNotNil(values.values, @"Values were nil");
	XCTAssert(values.values.count == 51, @"There were supposed to be 51 values, there were: %ld", values.values.count);
	G9Value *value = values.values[0];
	XCTAssert([value.label isEqualToString:@"L50"], @"The first value was: %@", value.label);
}

@end
