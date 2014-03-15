//
//  ZGParameterInfo.m
//  G9 Control
//
//  Created by Simon Biickert on 11/28/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import "G9ParameterInfo.h"
#import "G9RangeDomain.h"

@implementation G9ParameterInfo

+ (G9RangeDomain *) rangeForParameter:(NSUInteger)parameter
							  forType:(NSUInteger)typeIndex
							 inModule:(NSString *)moduleName
{
	G9RangeDomain *range = nil;
	
	NSUInteger zeroParam = parameter - 1;

	if ([moduleName isEqualToString:MODULE_COMP])
	{
		static NSArray *compParameterMinima;
		static NSArray *compParameterMaxima;
		if (!compParameterMinima) {
			compParameterMinima =
			@[@[@0,  @0,  @0,  @2], //COMP_COMPRESSOR
			  @[@0,  @1,  @0,  @2], //COMP_RACK
			  @[@0,  @1,  @0,  @2]];//COMP_LIMITER
			compParameterMaxima =
			@[@[@10, @1,  @10, @100], //COMP_COMPRESSOR
			  @[@50, @10, @10, @100], //COMP_RACK
			  @[@50, @10, @10, @100]];//COMP_LIMITER
		}
		
		range = [[G9RangeDomain alloc] initWithMinimum:((NSNumber *)compParameterMinima[typeIndex][zeroParam]).longValue
											andMaximum:((NSNumber *)compParameterMaxima[typeIndex][zeroParam]).longValue];
	}
	
	else if ([moduleName isEqualToString:MODULE_WAH])
	{
		static NSArray *wahParameterMinima;
		static NSArray *wahParameterMaxima;
		if (!wahParameterMinima) {
			wahParameterMinima =
			@[@[@0,  @2,  @0,  @2], //WAH_AUTOWAH
			  @[@0,  @2,  @0,  @2], //WAH_ARESONANCE
			  @[@1,  @0,  @0,  @2], //WAH_BOOSTER
			  @[@0,  @0,  @0,  @2], //WAH_TREMOLO
			  @[@0,  @0,  @1,  @2], //WAH_PHASER
			  @[@0,  @1,  @1,  @2], //WAH_FIXED_PHASER
			  @[@0,  @1,  @0,  @2], //WAH_RING_MODULATOR
			  @[@0,  @1,  @0,  @2], //WAH_SLOW_ATTACK
			  @[@0,  @1,  @0,  @2], //WAH_PEDAL_VOX
			  @[@0,  @1,  @0,  @2], //WAH_PEDAL_CRY
			  @[@0,  @1,  @1,  @2], //WAH_MULTI
			  @[@0,  @1,  @0,  @2], //WAH_PRESONANCE
			  @[@0,  @0,  @0,  @2], //WAH_OCTAVE
			  @[@0,  @1,  @0,  @2], //WAH_X_WAH
			  @[@0,  @0,  @0,  @2], //WAH_X_PHASER
			  @[@0,  @0,  @0,  @2], //WAH_X_VIBE
			  @[@0,  @0,  @0,  @0]];//WAH_Z_OSCILLATOR
			wahParameterMaxima =
			@[@[@1,  @10, @10, @100], //WAH_AUTOWAH
			  @[@1,  @10, @10, @100], //WAH_ARESONANCE
			  @[@1,  @10, @10, @100], //WAH_BOOSTER
			  @[@100,@50, @29, @100], //WAH_TREMOLO
			  @[@1,  @50, @4,  @100], //WAH_PHASER
			  @[@1,  @50, @4,  @100], //WAH_FIXED_PHASER
			  @[@1,  @50, @100,@100], //WAH_RING_MODULATOR
			  @[@1,  @50, @10, @100], //WAH_SLOW_ATTACK
			  @[@1,  @50, @10, @100], //WAH_PEDAL_VOX
			  @[@1,  @50, @10, @100], //WAH_PEDAL_CRY
			  @[@1,  @50, @10, @100], //WAH_MULTI
			  @[@1,  @50, @10, @100], //WAH_PRESONANCE
			  @[@100,@100,@10, @100], //WAH_OCTAVE
			  @[@1  ,@50 ,@100,@100], //WAH_X_WAH
			  @[@7  ,@50 ,@100,@100], //WAH_X_PHASER
			  @[@50 ,@50 ,@100,@100], //WAH_X_VIBE
			  @[@60 ,@10 ,@10, @100]];//WAH_Z_OSCILLATOR
		}
		
		range = [[G9RangeDomain alloc] initWithMinimum:((NSNumber *)wahParameterMinima[typeIndex][zeroParam]).longValue
											andMaximum:((NSNumber *)wahParameterMaxima[typeIndex][zeroParam]).longValue];
	}
	
	else if ([moduleName isEqualToString:MODULE_EXTLOOP])
	{
		// All ext loop params are 1 - 100
		range = [[G9RangeDomain alloc] initWithMinimum:1 andMaximum:100];
	}
	
	else if ([[moduleName substringToIndex:2] isEqualToString:MODULE_EQ])
	{
		// All six bands have a minValue of -12
		range = [[G9RangeDomain alloc] initWithMinimum:-12 andMaximum:12];
	}
	
	else if ([[moduleName substringToIndex:3] isEqualToString:MODULE_ZNR])
	{
		// All ZNR modules have one parameter and they are 1 - 16
		range = [[G9RangeDomain alloc] initWithMinimum:1 andMaximum:16];
	}
	
	else if ([[moduleName substringToIndex:3] isEqualToString:MODULE_AMP])
	{
		// Level (parameter 2) is the only one with a non-zero minValue
		NSInteger minValue = 0;
		if (parameter == 2)
		{
			minValue = 1;
		}

		static NSArray *ampParameterMaxima;
		if (!ampParameterMaxima) {
			ampParameterMaxima =
			@[@[@100,@100,@30, @1], //Amplifiers
			  @[@10, @100,@10, @1]];//Accoustic Simulator
		}
		
		if (typeIndex == AMP_ACO_SIM)
		{
			range = [[G9RangeDomain alloc] initWithMinimum:minValue
												andMaximum:((NSNumber *)ampParameterMaxima[AMP_ACOUSTIC_TYPES][zeroParam]).longValue];
		}
		else {
			range = [[G9RangeDomain alloc] initWithMinimum:minValue
												andMaximum:((NSNumber *)ampParameterMaxima[AMP_DISTORTION_TYPES][zeroParam]).longValue];
		}
	}
	
	else if ([moduleName isEqualToString:MODULE_CAB])
	{
		// All three settings minimum is 0
		if (parameter == 1) {
			range = [[G9RangeDomain alloc] initWithMinimum:0 andMaximum:CAB_MIC_CONDENSER];
		}
		else if (parameter == 2) {
			range = [[G9RangeDomain alloc] initWithMinimum:0 andMaximum:CAB_MICPOS_EDGE];
		}
		else if (parameter == 3) {
			range = [[G9RangeDomain alloc] initWithMinimum:0 andMaximum:2]; //depth
		}
	}
	
	else if ([moduleName isEqualToString:MODULE_MOD])
	{
		static NSArray *modParameterMinima;
		static NSArray *modParameterMaxima;
		if (!modParameterMinima) {
			modParameterMinima =
			@[@[@0,  @1,  @0,  @0], //MOD_CHORUS
			  @[@0,  @1,  @0,  @0], //MOD_STEREO_CHORUS
			  @[@0,  @1,  @0,  @0], //MOD_ENSEMBLE
			  @[@1,  @0,  @1,  @0], //MOD_MOD_DELAY
			  @[@0,  @0,@-10,  @0], //MOD_FLANGER
			  @[@-12,@0,@-25,  @0], //MOD_PITCH_SHIFT
			  @[@1,  @0,  @0,  @1], //MOD_PEDAL_PITCH
			  @[@0,  @0,  @0,  @0], //MOD_VIBE
			  @[@0,  @0,  @0,  @0], //MOD_STEP
			  @[@1,  @0,  @0,  @0], //MOD_DELAY
			  @[@1,  @0,  @0,  @0], //MOD_TAPE_ECHO
			  @[@1,  @0,  @0,@-10],  //MOD_DYNAMIC_DELAY
			  @[@0,  @0,@-10,@-10], //MOD_DYNAMIC_FLANGER
			  @[@-24,@0,@-25,  @0], //MOD_MONOPITCH
			  @[@-6, @0,  @0,  @0], //MOD_HPS
			  @[@1,  @0,  @0,  @0], //MOD_PEDAL_MONOPITCH
			  @[@1,  @0,@-10,  @0], //MOD_CRY
			  @[@10, @0,  @0,  @0], //MOD_REVERSE_DELAY
			  @[@-50,@1,  @1,  @0], //MOD_BEND_CHORUS
			  @[@1,  @-10,@0,  @0], //MOD_COMB_FILTER
			  @[@1,  @0,  @0,  @0], //MOD_AIR
			  @[@10, @0,  @0,  @0], //MOD_Z_ECHO
			  @[@0,  @0,  @0,  @0], //MOD_X_FLANGER
			  @[@0,  @0,  @0,  @0], //MOD_X_STEP
			  @[@1,  @0,  @0,  @0], //MOD_Z_STEP
			  @[@1,  @0,  @0,  @0], //MOD_Z_PITCH
			  @[@1,  @0,  @0,  @0], //MOD_Z_MONOPITCH
			  @[@1,  @0,  @0,  @0]];//MOD_Z_TALKING
			modParameterMaxima =
			@[@[@100, @50, @10, @100], //MOD_CHORUS
			  @[@100, @50, @10, @100], //MOD_STEREO_CHORUS
			  @[@100, @50, @10, @100], //MOD_ENSEMBLE
			  @[@2000,@100,@50, @100], //MOD_MOD_DELAY
			  @[@100, @50, @10, @100], //MOD_FLANGER
			  @[@24,  @10, @25, @100], //MOD_PITCH_SHIFT
			  @[@8,   @1,  @10, @100], //MOD_PEDAL_PITCH
			  @[@100, @50, @10, @100], //MOD_VIBE
			  @[@100, @50, @10, @10],  //MOD_STEP
			  @[@2000,@100,@10, @100], //MOD_DELAY
			  @[@2000,@100,@10, @100], //MOD_TAPE_ECHO
			  @[@2000,@100,@100,@10],  //MOD_DYNAMIC_DELAY
			  @[@100, @50, @10, @10],  //MOD_DYNAMIC_FLANGER
			  @[@24,  @10, @25, @100], //MOD_MONOPITCH
			  @[@6,   @11, @10, @100], //MOD_HPS
			  @[@8,   @1,  @10, @100], //MOD_PEDAL_MONOPITCH
			  @[@10,  @10, @10, @100], //MOD_CRY
			  @[@1000,@100,@10, @100], //MOD_REVERSE_DELAY
			  @[@50,  @10, @10, @100], //MOD_BEND_CHORUS
			  @[@50,  @10, @10, @100], //MOD_COMB_FILTER
			  @[@100, @10, @10, @100],  //MOD_AIR
			  @[@1000,@100,@10, @100], //MOD_Z_ECHO
			  @[@100, @50, @100,@100], //MOD_X_FLANGER
			  @[@100, @50, @100,@10],  //MOD_X_STEP
			  @[@50,  @100,@10, @100], //MOD_Z_STEP
			  @[@8,	  @10, @100,@100], //MOD_Z_PITCH
			  @[@8,   @10, @100,@100], //MOD_Z_MONOPITCH
			  @[@5,   @10, @100,@100]];//MOD_Z_TALKING
		}
		
		range = [[G9RangeDomain alloc] initWithMinimum:((NSNumber *)modParameterMinima[typeIndex][zeroParam]).longValue
											andMaximum:((NSNumber *)modParameterMaxima[typeIndex][zeroParam]).longValue];
	}
	
	else if ([moduleName isEqualToString:MODULE_DELAY])
	{
		static NSArray *delayParameterMinima;
		static NSArray *delayParameterMaxima;
		if (!delayParameterMinima) {
			delayParameterMinima =
			@[@[@1,  @0,  @0,  @0], //DELAY_DELAY
			  @[@1,  @0,  @0,  @0], //DELAY_PINGPONG
			  @[@1,  @0,  @0,  @0], //DELAY_ECHO
			  @[@1,  @0,  @0,  @0], //DELAY_PINGPONG_ECHO
			  @[@1,  @0,  @0,  @0], //DELAY_ANALOG
			  @[@10, @0,  @0,  @0], //DELAY_REVERSE_DELAY
			  @[@1,  @0,  @0,  @0]];  //DELAY_AIR
			delayParameterMaxima =
			@[@[@5000,@100,@10, @100], //DELAY_DELAY
			  @[@5000,@100,@10, @100], //DELAY_PINGPONG
			  @[@5000,@100,@10, @100], //DELAY_ECHO
			  @[@5000,@100,@10, @100], //DELAY_PINGPONG_ECHO
			  @[@5000,@100,@10, @100], //DELAY_ANALOG
			  @[@2500,@100,@10, @100], //DELAY_REVERSE_DELAY
			  @[@100, @10, @10, @100]];  //DELAY_AIR
		}
		range = [[G9RangeDomain alloc] initWithMinimum:((NSNumber *)delayParameterMinima[typeIndex][zeroParam]).longValue
											andMaximum:((NSNumber *)delayParameterMaxima[typeIndex][zeroParam]).longValue];
	}
	
	else if ([moduleName isEqualToString:MODULE_REVERB])
	{
		static NSArray *reverbParameterMinima;
		static NSArray *reverbParameterMaxima;
		if (!reverbParameterMinima) {
			reverbParameterMinima =
			@[@[@1,  @1,  @0,  @0],   //REVERB_HALL
			  @[@1,  @1,  @0,  @0],   //REVERB_ROOM
			  @[@1,  @1,  @0,  @0],   //REVERB_SPRING
			  @[@1,  @1,  @0,  @0],   //REVERB_ARENA
			  @[@1,  @1,  @0,  @0],   //REVERB_TILEDROOM
			  @[@1,  @1,  @0,  @0],   //REVERB_MODERNSPRING
			  @[@0,  @0,  @0,  @0],   //REVERB_EARLY_REFL
			  @[@0,  @0,  @0,  @0],   //REVERB_MULTITAP
			  @[@0,  @0,  @0,  @-50], //REVERB_PANDELAY
			  @[@0,  @0,  @0,  @0],   //REVERB_PINGPONG_D
			  @[@0,  @0,  @0,  @0],   //REVERB_PINGPONG_E
			  @[@0,  @0,  @0,  @0],	  //REVERB_AUTOPAN
			  @[@1,  @0,  @-50,@0],	  //REVERB_Z_DELAY
			  @[@-50,@0,  @1,  @0],	  //REVERB_Z_DIMENSION
			  @[@1,  @1,  @-50,@0]];  //REVERB_Z_TORNADO
			reverbParameterMaxima =
			@[
			  @[@30,  @100,@10, @100], //REVERB_HALL
			  @[@30,  @100,@10, @100], //REVERB_ROOM
			  @[@30,  @100,@10, @100], //REVERB_SPRING
			  @[@30,  @100,@10, @100], //REVERB_ARENA
			  @[@30,  @100,@10, @100], //REVERB_TILEDROOM
			  @[@30,  @100,@10, @100], //REVERB_MODERNSPRING
			  @[@30,  @10, @10, @100], //REVERB_EARLY_REFL
			  @[@3000,@8,  @10, @100], //REVERB_MULTITAP
			  @[@3000,@100,@10, @50],  //REVERB_PANDELAY
			  @[@3000,@100,@10, @100], //REVERB_PINGPONG_D
			  @[@3000,@100,@10, @100], //REVERB_PINGPONG_E
			  @[@50,  @50, @10, @10],  //REVERB_AUTOPAN
			  @[@3000,@100,@50, @100], //REVERB_Z_DELAY
			  @[@50,  @100,@30, @100], //REVERB_Z_DIMENSION
			  @[@3000,@50, @50, @100]];//REVERB_Z_TORNADO
		}
		range = [[G9RangeDomain alloc] initWithMinimum:((NSNumber *)reverbParameterMinima[typeIndex][zeroParam]).longValue
											andMaximum:((NSNumber *)reverbParameterMaxima[typeIndex][zeroParam]).longValue];
	}
	
	else if ([moduleName isEqualToString:MODULE_TOTAL])
	{
		if (parameter == 1) { // Tempo
			range = [[G9RangeDomain alloc] initWithMinimum:40 andMaximum:250];
		}
		else if (parameter == 2 || parameter == 3) { // Function Switch 1, 2
			range = [[G9RangeDomain alloc] initWithMinimum:TOTAL_FN_AMP_AB
												andMaximum:TOTAL_FN_REVERB_ONOFF];
		}
	}
	
	else if ([[moduleName substringToIndex:5] isEqualToString:MODULE_PEDAL])
	{
		if (parameter == 1) { // Target for expression pedal
			range = [[G9RangeDomain alloc] initWithMinimum:CONTROL_NOT_ASSIGNED andMaximum:CONTROL_MAX];
		}
		else if (parameter == 2) { // Minimum value when pedal up
			// Depends on the target
		}
		else if (parameter == 3) { // Maximum value when pedal down
			// Depends on the target
		}
		else if (parameter == 4) { // Module on/off function
			
		}
	}
	
	else if ([moduleName isEqualToString:MODULE_ARRM])
	{
		if (parameter == 1) { // Target for ARRM
			range = [[G9RangeDomain alloc] initWithMinimum:CONTROL_NOT_ASSIGNED andMaximum:CONTROL_MAX];
		}
		else if (parameter == 2) { // Minimum value
			// Depends on the target
		}
		else if (parameter == 3) { // Maximum value
			// Depends on the target
		}
		else if (parameter == 4) { // Wave form
			G9ValueDomain *domain =[[G9ValueDomain alloc] init];
			for (long i = 1; i <= 8; i++) {
				NSString *key = [G9ParameterInfo keyForModule:moduleName
												 andTypeIndex:typeIndex
											andParameterIndex:parameter
												andValueIndex:i];
				[domain addValue:[[G9Value alloc] initWithValue:(NSInteger)i
													   andLabel:NSLocalizedStringFromTable(key, @"Names", nil)]];
			}
			range = domain;
		}
		else if (parameter == 5) { // Sync
			G9ValueDomain *syncDomain =[[G9ValueDomain alloc] init];
			[syncDomain addValue:[[G9Value alloc] initWithValue:0 andLabel:@"1/8"]];
			[syncDomain addValue:[[G9Value alloc] initWithValue:1 andLabel:@"1/4"]];
			for (long i = 2; i <= 20; i++) {
				[syncDomain addValue:[[G9Value alloc] initWithValue:i andLabel:[NSString stringWithFormat:@"1/4 x %ld", i]]];
			}
			range = syncDomain;
		}
	}
	
	// See if there is a domain for the parameter
	G9RangeDomain *domain = [G9ParameterInfo domainForParameter:parameter forType:typeIndex inModule:moduleName];
	
	// Return the domain if so
	return domain == nil ? range : domain;
}

+ (G9RangeDomain *) domainForParameter:(NSUInteger)parameter forType:(NSUInteger)typeIndex inModule:(NSString *)moduleName
{
	G9ValueDomain *domain;
	
	// These are all of the exceptional cases for effects that aren't just simple value ranges
	if ([moduleName isEqualToString:MODULE_COMP])
	{
		if (typeIndex == COMP_COMPRESSOR && parameter == 2)
		{
			domain = [[G9ValueDomain alloc] init];
			[domain addValue:[[G9Value alloc] initWithValue:COMP_ATTACK_FAST andLabel:[G9ParameterInfo labelForValue:COMP_ATTACK_FAST forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
			[domain addValue:[[G9Value alloc] initWithValue:COMP_ATTACK_SLOW andLabel:[G9ParameterInfo labelForValue:COMP_ATTACK_SLOW forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
		}
	}
	
	else if ([moduleName isEqualToString:MODULE_WAH])
	{
		if (parameter == 1)
		{
			if (typeIndex == WAH_AUTOWAH || typeIndex == WAH_ARESONANCE || typeIndex == WAH_PHASER
				|| typeIndex == WAH_FIXED_PHASER || typeIndex == WAH_RING_MODULATOR || typeIndex == WAH_SLOW_ATTACK
				|| typeIndex == WAH_PEDAL_VOX || typeIndex == WAH_PEDAL_CRY || typeIndex == WAH_MULTI
				|| typeIndex == WAH_PRESONANCE || typeIndex == WAH_X_WAH)
			{
				// Simple Before, After
				domain = [[G9ValueDomain alloc] init];
				[domain addValue:[[G9Value alloc] initWithValue:WAH_BEFORE andLabel:[G9ParameterInfo labelForValue:WAH_BEFORE forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
				[domain addValue:[[G9Value alloc] initWithValue:WAH_AFTER andLabel:[G9ParameterInfo labelForValue:WAH_AFTER forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
			}
			else if (typeIndex == WAH_X_PHASER)
			{
				// Combination of Before, After and sound type 1-4
				domain = [[G9ValueDomain alloc] init];
				for (NSUInteger i = 0; i < 8; i++) {
					[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[G9ParameterInfo labelForValue:i forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
				}
			}
			else if (typeIndex == WAH_Z_OSCILLATOR)
			{
				// 0-60 Values, plus 61 Auto-Before and 62 Auto-After
				domain = [[G9ValueDomain alloc] init];
				[domain addValue:[[G9Value alloc] initWithValue:0 andLabel:[G9ParameterInfo labelForValue:0 forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
				[domain addValue:[[G9Value alloc] initWithValue:12 andLabel:[G9ParameterInfo labelForValue:12 forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
				[domain addValue:[[G9Value alloc] initWithValue:24 andLabel:[G9ParameterInfo labelForValue:24 forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
				[domain addValue:[[G9Value alloc] initWithValue:36 andLabel:[G9ParameterInfo labelForValue:36 forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
				[domain addValue:[[G9Value alloc] initWithValue:48 andLabel:[G9ParameterInfo labelForValue:48 forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
				[domain addValue:[[G9Value alloc] initWithValue:60 andLabel:[G9ParameterInfo labelForValue:60 forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
				[domain addValue:[[G9Value alloc] initWithValue:61 andLabel:[G9ParameterInfo labelForValue:61 forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
				[domain addValue:[[G9Value alloc] initWithValue:62 andLabel:[G9ParameterInfo labelForValue:62 forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
			}
		}
		else if ((typeIndex == WAH_AUTOWAH || typeIndex == WAH_ARESONANCE) && parameter == 2)
		{
			// Sense is -10 to 1, 1 to 10 no zero
			domain = [[G9ValueDomain alloc] init];
			for (NSInteger i = -10; i < 0; i++) {
				[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[NSString stringWithFormat:@"%ld", i]]];
			}
			for (NSInteger i = 1; i <= 10; i++) {
				[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[NSString stringWithFormat:@"%ld", i]]];
			}
		}
		else if (typeIndex == WAH_TREMOLO && parameter == 3)
		{
			// Wave is UP 0-9, DOWN 0-9 or TRI 0-9
			domain = [[G9ValueDomain alloc] init];
			for (NSInteger i = 0; i < 30; i++) {
				[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[G9ParameterInfo labelForValue:i forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
			}
		}
	}
	
	else if ([moduleName isEqualToString:MODULE_EXTLOOP])
	{
		// No exceptions
	}
	
	else if ([[moduleName substringToIndex:2] isEqualToString:MODULE_EQ])
	{
		// No exceptions
	}
	
	else if ([[moduleName substringToIndex:3] isEqualToString:MODULE_ZNR])
	{
		// No exceptions
	}
	
	else if ([[moduleName substringToIndex:3] isEqualToString:MODULE_AMP])
	{
		if (parameter == 4)
		{
			// Chain is Pre or Post
			domain = [[G9ValueDomain alloc] init];
			[domain addValue:[[G9Value alloc] initWithValue:AMP_PRE andLabel:[G9ParameterInfo labelForValue:AMP_PRE forParameter:parameter forType:AMP_DISTORTION_TYPES inModuleNamed:moduleName]]];
			[domain addValue:[[G9Value alloc] initWithValue:AMP_POST andLabel:[G9ParameterInfo labelForValue:AMP_POST forParameter:parameter forType:AMP_DISTORTION_TYPES inModuleNamed:moduleName]]];
		}
	}
	
	else if ([moduleName isEqualToString:MODULE_CAB])
	{
		if (parameter == 1)
		{
			// Dynamic or Condenser
			domain = [[G9ValueDomain alloc] init];
			[domain addValue:[[G9Value alloc] initWithValue:CAB_MIC_DYNAMIC andLabel:[G9ParameterInfo labelForValue:CAB_MIC_DYNAMIC forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
			[domain addValue:[[G9Value alloc] initWithValue:CAB_MIC_CONDENSER andLabel:[G9ParameterInfo labelForValue:CAB_MIC_CONDENSER forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
		}
		else if (parameter == 2)
		{
			// Mic position
			domain = [[G9ValueDomain alloc] init];
			[domain addValue:[[G9Value alloc] initWithValue:CAB_MICPOS_CENTER andLabel:[G9ParameterInfo labelForValue:CAB_MICPOS_CENTER forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
			[domain addValue:[[G9Value alloc] initWithValue:CAB_MICPOS_HALF andLabel:[G9ParameterInfo labelForValue:CAB_MICPOS_HALF forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
			[domain addValue:[[G9Value alloc] initWithValue:CAB_MICPOS_EDGE andLabel:[G9ParameterInfo labelForValue:CAB_MICPOS_EDGE forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
		}
	}
	
	else if ([moduleName isEqualToString:MODULE_MOD])
	{
		if (typeIndex == MOD_PITCH_SHIFT && parameter == 1)
		{
			// -12 to +12, plus 24
			domain = [[G9ValueDomain alloc] init];
			for (NSInteger i = -12; i <= 12; i++) {
				[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[NSString stringWithFormat:@"%ld", i]]];
			}
			[domain addValue:[[G9Value alloc] initWithValue:24 andLabel:[NSString stringWithFormat:@"%d", 24]]];
		}
		else if ((typeIndex == MOD_PEDAL_PITCH || typeIndex == MOD_PEDAL_MONOPITCH) && parameter == 1)
		{
			// Color 1-8
			domain = [[G9ValueDomain alloc] init];
			for (NSInteger i = 1; i <= 8; i++)
			{
				[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[G9ParameterInfo labelForValue:i forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
			}
		}
		else if ((typeIndex == MOD_PEDAL_PITCH || typeIndex == MOD_PEDAL_MONOPITCH) && parameter == 2)
		{
			// Up, down
			domain = [[G9ValueDomain alloc] init];
			[domain addValue:[[G9Value alloc] initWithValue:MOD_PEDAL_UP andLabel:[G9ParameterInfo labelForValue:MOD_PEDAL_UP forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
			[domain addValue:[[G9Value alloc] initWithValue:MOD_PEDAL_DOWN andLabel:[G9ParameterInfo labelForValue:MOD_PEDAL_DOWN forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
		}
		else if ((typeIndex == MOD_DYNAMIC_DELAY || typeIndex == MOD_DYNAMIC_FLANGER) && parameter == 4)
		{
			// Sense is -10 to 1, 1 to 10 no zero
			domain = [[G9ValueDomain alloc] init];
			for (NSInteger i = -10; i < 0; i++) {
				[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[NSString stringWithFormat:@"%ld", i]]];
			}
			for (NSInteger i = 1; i <= 10; i++) {
				[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[NSString stringWithFormat:@"%ld", i]]];
			}
		}
		else if (typeIndex == MOD_HPS)
		{
			if (parameter == 1)
			{
				// Scale between sixth down and sixth up
				domain = [[G9ValueDomain alloc] init];
				for (NSInteger i = 0; i <= 9; i++) {
					[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[G9ParameterInfo labelForValue:i forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
				}
			}
			else if (parameter == 2)
			{
				// Key C to Bb
				domain = [[G9ValueDomain alloc] init];
				for (NSInteger i = 0; i <= 11; i++) {
					[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[G9ParameterInfo labelForValue:i forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
				}
			}
		}
		else if (typeIndex == MOD_CRY && parameter == 3)
		{
			// Sense is -10 to 1, 1 to 10 no zero
			domain = [[G9ValueDomain alloc] init];
			for (NSInteger i = -10; i < 0; i++) {
				[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[NSString stringWithFormat:@"%ld", i]]];
			}
			for (NSInteger i = 1; i <= 10; i++) {
				[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[NSString stringWithFormat:@"%ld", i]]];
			}
		}
		else if ((typeIndex == MOD_Z_PITCH || typeIndex == MOD_Z_MONOPITCH) && parameter == 1)
		{
			// Color 1-8
			domain = [[G9ValueDomain alloc] init];
			for (NSInteger i = 1; i <= 8; i++)
			{
				[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[G9ParameterInfo labelForValue:i forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
			}
		}
		else if (typeIndex == MOD_Z_TALKING && parameter == 1)
		{
			// Variation 1-5
			domain = [[G9ValueDomain alloc] init];
			for (NSInteger i = 1; i <= 5; i++)
			{
				[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[G9ParameterInfo labelForValue:i forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
			}
		}
	}
	
	else if ([moduleName isEqualToString:MODULE_DELAY])
	{
		// No exceptions
	}
	
	else if ([moduleName isEqualToString:MODULE_REVERB])
	{
		if ((typeIndex == REVERB_PANDELAY && parameter == 4)
			|| (typeIndex == REVERB_AUTOPAN && parameter == 1)
			|| (typeIndex == REVERB_Z_DIMENSION && parameter == 1)
			|| (typeIndex == REVERB_Z_TORNADO && parameter == 3))
		{
			// Panning by twos from L50 to R50
			domain = [[G9ValueDomain alloc] init];
			for (int i = -50; i <= 50; i+=2)
			{
				if (i < 0) {
					[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[NSString stringWithFormat:@"L%d", abs(i)]]];
				}
				else if (i > 0) {
					[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[NSString stringWithFormat:@"R%d", i]]];
				}
				else {
					[domain addValue:[[G9Value alloc] initWithValue:i andLabel:[NSString stringWithFormat:@"%d", i]]];
				}
			}
		}
	}
	
	else if ([moduleName isEqualToString:MODULE_PEDAL])
	{
		if (parameter == 4)
		{
			domain = [[G9ValueDomain alloc] init];
			NSInteger off = [[NSNumber numberWithBool:NO] integerValue];
			NSInteger on = [[NSNumber numberWithBool:YES] integerValue];
			[domain addValue:[[G9Value alloc] initWithValue:off andLabel:[G9ParameterInfo labelForValue:off forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
			[domain addValue:[[G9Value alloc] initWithValue:on andLabel:[G9ParameterInfo labelForValue:on forParameter:parameter forType:typeIndex inModuleNamed:moduleName]]];
		}
	}
	
	else if ([moduleName isEqualToString:MODULE_TOTAL])
	{
		// No exceptions
	}
	
	return domain;
}
	
+ (G9RangeDomain *) rangeForPedalWithControlTargetIndex:(NSUInteger)controlTargetIndex
{
	NSString *key = [G9ParameterInfo keysForControlTargetIndexes][controlTargetIndex];
	NSString *moduleName = [G9ParameterInfo moduleNameFromKey:key];
	NSUInteger typeIndex = [G9ParameterInfo typeIndexFromKey:key];
	NSUInteger parameter = [G9ParameterInfo parameterFromKey:key];
	
	return [G9ParameterInfo rangeForParameter:parameter
									  forType:typeIndex
									 inModule:moduleName];
}
	
+ (NSUInteger) controlTargetIndexForParameter:(NSUInteger)parameter forType:(NSUInteger)typeIndex inModuleNamed:(NSString *)moduleName
{
	return [G9ParameterInfo controlTargetIndexForKey:[G9ParameterInfo keyForModule:moduleName
																	  andTypeIndex:typeIndex
																 andParameterIndex:parameter]];
}

+ (NSUInteger) parameterCountForModuleNamed:(NSString *)moduleName
{
	static NSDictionary *moduleParameterCounts;
	if (!moduleParameterCounts) {
		moduleParameterCounts = @{
			MODULE_COMP: @4,
			MODULE_WAH: @4,
			MODULE_EXTLOOP: @3,
			MODULE_CAB: @3,
			MODULE_MOD: @4,
			MODULE_DELAY: @4,
			MODULE_REVERB: @4,
			MODULE_TOTAL: @3,
			MODULE_ARRM: @5
		};
	}
	
	NSUInteger paramCount = 0;
	if (moduleParameterCounts[moduleName])
	{
		paramCount = ((NSNumber *)moduleParameterCounts[moduleName]).longValue;
	}
	else if ([[moduleName substringToIndex:2] isEqualToString:MODULE_EQ])
	{
		paramCount = 6;
	}
	else if ([[moduleName substringToIndex:3] isEqualToString:MODULE_ZNR])
	{
		paramCount = 1;
	}
	else if ([[moduleName substringToIndex:3] isEqualToString:MODULE_AMP])
	{
		paramCount = 4;
	}
	else if ([[moduleName substringToIndex:5] isEqualToString:MODULE_PEDAL])
	{
		paramCount = 4;
	}
	return paramCount;
}

+ (NSUInteger) typeCountForModuleNamed:(NSString *)moduleName
{
	static NSDictionary *moduleTypeCounts;
	if (!moduleTypeCounts) {
		moduleTypeCounts = @{
			  MODULE_COMP: @3,
			  MODULE_ZNR: @3,
			  MODULE_WAH: @17,
			  MODULE_AMP: @44,
			  MODULE_MOD: @28,
			  MODULE_DELAY: @7,
			  MODULE_REVERB: @15
		  };
	}
	
	NSUInteger typeCount = 0;
	if (moduleTypeCounts[moduleName])
	{
		typeCount = ((NSNumber *)moduleTypeCounts[moduleName]).longValue;
	}
	return typeCount;
}

#pragma mark String file key generators

+ (NSString *) keyForModule:(NSString *)moduleName
			   andTypeIndex:(NSUInteger)typeIndex
{
	return [NSString stringWithFormat:@"%@.%ld", moduleName, typeIndex];
}

+ (NSString *) keyForModule:(NSString *)moduleName
			   andTypeIndex:(NSUInteger)typeIndex
		  andParameterIndex:(NSUInteger)parameterIndex
{
	return [NSString stringWithFormat:@"%@.%ld.%ld", moduleName, typeIndex, parameterIndex];
}

+ (NSString *) keyForModule:(NSString *)moduleName
			   andTypeIndex:(NSUInteger)typeIndex
		  andParameterIndex:(NSUInteger)parameterIndex
			  andValueIndex:(NSUInteger)valueIndex
{
	return [NSString stringWithFormat:@"%@.%ld.%ld.%ld", moduleName, typeIndex, parameterIndex, valueIndex];
}
	
+ (NSString *) moduleNameFromKey:(NSString *)key
{
	NSArray *list = [key componentsSeparatedByString:@"."];
	return list[0];
}
	
+ (NSUInteger) typeIndexFromKey:(NSString *)key
{
	NSArray *list = [key componentsSeparatedByString:@"."];

	return [((NSString *)list[1]) integerValue];
}
	
+ (NSUInteger) parameterFromKey:(NSString *)key
{
	NSArray *list = [key componentsSeparatedByString:@"."];
	return [((NSString *)list[2]) integerValue];
}
	
+ (NSArray *) keysForControlTargetIndexes
{
	static NSArray *keysByCTIndex;
	if (!keysByCTIndex) {
		keysByCTIndex = @[  @"control.0", @"control.1",
							@"wah.0.2", @"wah.0.3", @"wah.0.4", @"wah.1.2", @"wah.1.3",
							@"wah.1.4", @"wah.2.3", @"wah.2.4", @"wah.3.1", @"wah.3.2",
							@"wah.3.3", @"wah.3.4", @"wah.4.2", @"wah.4.4", @"wah.5.2",
							@"wah.5.4", @"wah.6.2", @"wah.6.3", @"wah.6.4", @"wah.7.2",
							@"wah.7.3", @"wah.7.4", @"wah.8.2", @"wah.8.3", @"wah.8.4",
							@"wah.9.2", @"wah.9.3", @"wah.9.4", @"wah.10.2", @"wah.10.4",
							@"wah.11.2", @"wah.11.3", @"wah.11.4", @"wah.12.1", @"wah.12.2",
							@"wah.12.4", @"wah.13.2", @"wah.13.3", @"wah.14.2", @"wah.14.3",
							@"wah.15.1", @"wah.15.2", @"wah.15.3", @"wah.16.1", @"wah.16.2",
							@"wah.16.3", @"wah.16.4",
							@"extLoop.0.1", @"extLoop.0.2", @"extLoop.0.3",
							@"amp.0.1", @"amp.0.2", @"amp.1.1", @"amp.1.2", @"amp.2.1",
							@"amp.2.2", @"amp.3.1", @"amp.3.2", @"amp.4.1", @"amp.4.2",
							@"amp.5.1", @"amp.5.2", @"amp.6.1", @"amp.6.2", @"amp.7.1",
							@"amp.7.2", @"amp.8.1", @"amp.8.2", @"amp.9.1", @"amp.9.2",
							@"amp.10.1", @"amp.10.2", @"amp.11.1", @"amp.11.2", @"amp.12.1",
							@"amp.12.2", @"amp.13.1", @"amp.13.2", @"amp.14.1", @"amp.14.2",
							@"amp.15.1", @"amp.15.2", @"amp.16.1", @"amp.16.2", @"amp.17.1",
							@"amp.17.2", @"amp.18.1", @"amp.18.2", @"amp.19.1", @"amp.19.2",
							@"amp.20.1", @"amp.20.2", @"amp.21.1", @"amp.21.2", @"amp.22.1",
							@"amp.22.2", @"amp.23.1", @"amp.23.2", @"amp.24.1", @"amp.24.2",
							@"amp.25.1", @"amp.25.2", @"amp.26.1", @"amp.26.2", @"amp.27.1",
							@"amp.27.2", @"amp.28.1", @"amp.28.2", @"amp.29.1", @"amp.29.2",
							@"amp.30.1", @"amp.30.2", @"amp.31.1", @"amp.31.2", @"amp.32.1",
							@"amp.32.2", @"amp.33.1", @"amp.33.2", @"amp.34.1", @"amp.34.2",
							@"amp.35.1", @"amp.35.2", @"amp.36.1", @"amp.36.2", @"amp.37.1",
							@"amp.37.2", @"amp.38.1", @"amp.38.2", @"amp.39.1", @"amp.39.2",
							@"amp.40.1", @"amp.40.2", @"amp.41.1", @"amp.41.2", @"amp.42.1",
							@"amp.42.2", @"amp.43.1", @"amp.43.2",
							@"mod.0.2", @"mod.0.4", @"mod.1.1", @"mod.1.2", @"mod.1.4",
							@"mod.2.4", @"mod.3.2", @"mod.3.3", @"mod.3.4", @"mod.4.1",
							@"mod.4.2", @"mod.4.3", @"mod.4.4", @"mod.5.4", @"mod.6.4",
							@"mod.7.1", @"mod.7.2", @"mod.7.4", @"mod.8.1", @"mod.8.2",
							@"mod.8.3", @"mod.8.4", @"mod.9.2", @"mod.9.4", @"mod.10.2",
							@"mod.10.4", @"mod.11.2", @"mod.11.3", @"mod.11.4", @"mod.12.1",
							@"mod.12.2", @"mod.12.3", @"mod.12.4", @"mod.13.4", @"mod.14.4",
							@"mod.15.4", @"mod.16.1", @"mod.16.2", @"mod.16.3", @"mod.16.4",
							@"mod.17.2", @"mod.17.4", @"mod.18.1", @"mod.18.2", @"mod.18.3",
							@"mod.18.4", @"mod.19.1", @"mod.19.2", @"mod.19.4", @"mod.20.2",
							@"mod.20.4", @"mod.21.1", @"mod.21.2", @"mod.21.4", @"mod.22.2",
							@"mod.22.3", @"mod.23.2", @"mod.23.3", @"mod.24.1", @"mod.24.4",
							@"mod.25.3", @"mod.25.4", @"mod.26.3", @"mod.26.4", @"mod.27.3",
							@"mod.27.4",
							@"delay.0.1", @"delay.0.3", @"delay.1.1", @"delay.1.3", @"delay.2.1",
							@"delay.2.3", @"delay.3.1", @"delay.3.3", @"delay.4.1", @"delay.4.3",
							@"delay.5.1", @"delay.5.3", @"delay.6.1", @"delay.6.3",
							@"reverb.0.1", @"reverb.0.4", @"reverb.1.1", @"reverb.1.4", @"reverb.2.1",
							@"reverb.2.4", @"reverb.3.1", @"reverb.3.4", @"reverb.4.1", @"reverb.4.4",
							@"reverb.5.1", @"reverb.5.4", @"reverb.6.2", @"reverb.6.4", @"reverb.7.4",
							@"reverb.8.2", @"reverb.8.4", @"reverb.9.2", @"reverb.9.4", @"reverb.10.2", 
							@"reverb.10.4", @"reverb.11.1", @"reverb.11.2", @"reverb.11.3", @"reverb.11.4", 
							@"reverb.12.3", @"reverb.12.4", @"reverb.13.1", @"reverb.13.2", @"reverb.14.2", 
							@"reverb.14.3", @"reverb.14.4"];
	}
	return keysByCTIndex;
}
	
+ (NSUInteger)controlTargetIndexForKey:(NSString *)key
{
	for (NSUInteger i = 0; i < [G9ParameterInfo keysForControlTargetIndexes].count; i++)
	{
		NSString *storedKey = [[G9ParameterInfo keysForControlTargetIndexes] objectAtIndex:i];
		if ([key isEqualToString:storedKey]) {
			return i;
		}
	}
	return 0;
}

#pragma mark Name and Description convenience functions

+ (NSString *) nameForType:(NSUInteger)typeIndex
			 inModuleNamed:(NSString *)moduleName
{
	NSString *key = [G9ParameterInfo keyForModule:moduleName andTypeIndex:typeIndex];
	return NSLocalizedStringFromTable(key, @"Names", nil);
}

+ (NSString *) descriptionForType:(NSUInteger)typeIndex
					inModuleNamed:(NSString *)moduleName
{
	NSString *key = [G9ParameterInfo keyForModule:moduleName andTypeIndex:typeIndex];
	return NSLocalizedStringFromTable(key, @"Descriptions", nil);
}


+ (NSString *) nameForParameter:(NSUInteger)parameter
						forType:(NSUInteger)typeIndex
				  inModuleNamed:(NSString *)moduleName
{
	if ([moduleName isEqualToString:MODULE_AMP])
	{
		if (typeIndex == AMP_ACO_SIM) {
			typeIndex = AMP_ACOUSTIC_TYPES;
		}
		else {
			typeIndex = AMP_DISTORTION_TYPES;
		}
	}
	NSString *key = [G9ParameterInfo keyForModule:moduleName
									 andTypeIndex:typeIndex
								andParameterIndex:parameter];
	return NSLocalizedStringFromTable(key, @"Names", nil);
}

+ (NSString *) descriptionForParameter:(NSUInteger)parameter
							   forType:(NSUInteger)typeIndex
						 inModuleNamed:(NSString *)moduleName
{
	if ([moduleName isEqualToString:MODULE_AMP])
	{
		if (typeIndex == AMP_ACO_SIM) {
			typeIndex = AMP_ACOUSTIC_TYPES;
		}
		else {
			typeIndex = AMP_DISTORTION_TYPES;
		}
	}
	NSString *key = [G9ParameterInfo keyForModule:moduleName
									 andTypeIndex:typeIndex
								andParameterIndex:parameter];
	return NSLocalizedStringFromTable(key, @"Descriptions", nil);
}

+ (NSString *) labelForValue:(NSInteger)value forParameter:(NSUInteger)parameter forType:(NSUInteger)typeIndex inModuleNamed:(NSString *)moduleName
{
	if ([moduleName isEqualToString:MODULE_AMP])
	{
		if (typeIndex == AMP_ACO_SIM) {
			typeIndex = AMP_ACOUSTIC_TYPES;
		}
		else {
			typeIndex = AMP_DISTORTION_TYPES;
		}
	}
	NSString *key = [G9ParameterInfo keyForModule:moduleName
									 andTypeIndex:typeIndex
								andParameterIndex:parameter
									andValueIndex:value];
	return NSLocalizedStringFromTable(key, @"Names", nil);
}

+ (NSString *) descriptionForValue:(NSInteger)value forParameter:(NSUInteger)parameter forType:(NSUInteger)typeIndex inModuleNamed:(NSString *)moduleName
{
	if ([moduleName isEqualToString:MODULE_AMP])
	{
		if (typeIndex == AMP_ACO_SIM) {
			typeIndex = AMP_ACOUSTIC_TYPES;
		}
		else {
			typeIndex = AMP_DISTORTION_TYPES;
		}
	}
	NSString *key = [G9ParameterInfo keyForModule:moduleName
									 andTypeIndex:typeIndex
								andParameterIndex:parameter
									andValueIndex:value];
	return NSLocalizedStringFromTable(key, @"Descriptions", nil);
}

+ (NSString *) labelForControlTargetIndex:(NSUInteger)controlTargetIndex
{
	NSString *key = [[G9ParameterInfo keysForControlTargetIndexes] objectAtIndex:controlTargetIndex];
	
	// control.0 ("Not Assigned") and control.1 ("Volume")
	if (controlTargetIndex <= 1) {
		return NSLocalizedStringFromTable(key, @"Names", nil);
	}
	
	NSString *moduleName = [G9ParameterInfo moduleNameFromKey:key];
	NSUInteger typeIndex = [G9ParameterInfo typeIndexFromKey:key];
	NSUInteger parameter = [G9ParameterInfo parameterFromKey:key];
	
	return [NSString stringWithFormat:@"%@ - %@ - %@", NSLocalizedStringFromTable(moduleName, @"Names", nil),
			[G9ParameterInfo nameForType:typeIndex inModuleNamed:moduleName],
			[G9ParameterInfo nameForParameter:parameter forType:typeIndex inModuleNamed:moduleName]];
}
@end
