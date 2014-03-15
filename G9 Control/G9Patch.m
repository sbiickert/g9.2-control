//
//  G9Patch.m
//  G9 Control
//
//  Created by Simon Biickert on 12/28/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import "G9Patch.h"
#import "G9PatchSet.h"
#import "G9Module.h"
#import "G9ParameterInfo.h"

@implementation G9Patch

@dynamic ampSelection;
@dynamic patchLevel;
@dynamic ampA;
@dynamic ampB;
@dynamic arrm;
@dynamic cab;
@dynamic comment;
@dynamic comp;
@dynamic delay;
@dynamic eqA;
@dynamic eqB;
@dynamic extLoop;
@dynamic mod;
@dynamic name;
@dynamic pedal1v1;
@dynamic pedal1v2;
@dynamic pedal1v3;
@dynamic pedal1v4;
@dynamic pedal2h1;
@dynamic pedal2h2;
@dynamic pedal2h3;
@dynamic pedal2h4;
@dynamic pedal2v1;
@dynamic pedal2v2;
@dynamic pedal2v3;
@dynamic pedal2v4;
@dynamic reverb;
@dynamic total;
@dynamic wah;
@dynamic znrA;
@dynamic znrB;
@dynamic patchBank;
@dynamic patchIndex;
@dynamic patchSet;

// Manually added
@synthesize modules = _modules;

- (NSMutableArray *) modules
{
	if (!_modules)
	{
		_modules = [NSMutableArray arrayWithArray: @[
			 [[G9Module alloc] initWithModuleName:MODULE_COMP patch:self],
			 [[G9Module alloc] initWithModuleName:MODULE_WAH patch:self],
			 [[G9Module alloc] initWithModuleName:MODULE_EXTLOOP patch:self],
			 [[G9Module alloc] initWithModuleName:MODULE_ZNR patch:self],
			 [[G9Module alloc] initWithModuleName:MODULE_AMP patch:self],
			 [[G9Module alloc] initWithModuleName:MODULE_EQ patch:self],
			 [[G9Module alloc] initWithModuleName:MODULE_CAB patch:self],
			 [[G9Module alloc] initWithModuleName:MODULE_MOD patch:self],
			 [[G9Module alloc] initWithModuleName:MODULE_DELAY patch:self],
			 [[G9Module alloc] initWithModuleName:MODULE_REVERB patch:self]
			 ]];
		
	}
	return _modules;
}
@end
