//
//  ZGParameterInfo.h
//  G9 Control
//
//  Created by Simon Biickert on 11/28/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "G9ValueDomain.h"
#import "G9RangeDomain.h"

#define MODULE_COMP			@"comp"
#define MODULE_WAH			@"wah"
#define MODULE_EXTLOOP		@"extLoop"
#define MODULE_ZNR			@"znr"
#define MODULE_AMP			@"amp"
#define MODULE_EQ			@"eq"
#define MODULE_CAB			@"cab"
#define MODULE_MOD			@"mod"
#define MODULE_DELAY		@"delay"
#define MODULE_REVERB		@"reverb"
#define MODULE_TOTAL		@"total"
#define MODULE_PEDAL		@"pedal"
#define MODULE_ARRM			@"arrm"
#define MODULE_CONTROL		@"control" // for "not assigned" and "volume"

#define COMP_COMPRESSOR		0
#define COMP_RACK			1
#define COMP_LIMITER		2

#define COMP_ATTACK_FAST	0
#define COMP_ATTACK_SLOW	1

#define ZNR_ZNR				0
#define ZNR_NOISE_GATE		1
#define ZNR_DIRTY_GATE		2

#define WAH_BEFORE			0
#define WAH_AFTER			1

#define WAH_AUTOWAH			0
#define WAH_ARESONANCE		1
#define WAH_BOOSTER			2
#define WAH_TREMOLO			3
#define WAH_PHASER			4
#define WAH_FIXED_PHASER	5
#define WAH_RING_MODULATOR	6
#define WAH_SLOW_ATTACK		7
#define WAH_PEDAL_VOX		8
#define WAH_PEDAL_CRY		9
#define WAH_MULTI			10
#define WAH_PRESONANCE		11
#define WAH_OCTAVE			12
#define WAH_X_WAH			13
#define WAH_X_PHASER		14
#define WAH_X_VIBE			15
#define WAH_Z_OSCILLATOR	16

#define AMP_SELECTION_A		0
#define AMP_SELECTION_B		1

#define AMP_DISTORTION_TYPES	0
#define AMP_ACOUSTIC_TYPES		1

#define AMP_PRE				0
#define AMP_POST			1

#define AMP_FENDER_CLEAN	0
#define AMP_VOX_CLEAN		1
#define AMP_JC_CLEAN		2
#define AMP_HIWATT_CLEAN	3
#define AMP_UK_BLUES		4
#define AMP_US_BLUES		5
#define AMP_TWEED_BASS		6
#define AMP_BG_CRUNCH		7
#define AMP_VOX_CRUNCH		8
#define AMP_Z_COMBO			9
#define AMP_MS_1959			10
#define AMP_MS_CRUNCH		11
#define AMP_MS_DRIVE		12
#define AMP_RECT_CLEAN		13
#define AMP_RECT_VINTAGE	14
#define AMP_RECT_MODERN		15
#define AMP_HK_CLEAN		16
#define AMP_HK_CRUNCH		17
#define AMP_HK_DRIVE		18
#define AMP_DZ_CLEAN		19
#define AMP_DZ_CRUNCH		20
#define AMP_DZ_DRIVE		21
#define AMP_ENGL_DRIVE		22
#define AMP_PV_DRIVE		23
#define AMP_Z_STACK			24
#define AMP_OVERDRIVE		25
#define AMP_TS808			26
#define AMP_CENTAUR			27
#define AMP_GUVNOR			28
#define AMP_RAT				29
#define AMP_DS_1			30
#define AMP_MXR_DST			31
#define AMP_HOTBOX			32
#define AMP_FUZZFACE		33
#define AMP_BIGMUFF			34
#define AMP_METAL_ZONE		35
#define AMP_TS9_COMBO		36
#define AMP_SD1_STACK		37
#define AMP_FUZZ_STACK		38
#define AMP_Z_OVERDRIVE		39
#define AMP_EXTREME_DS		40
#define AMP_DIGI_FUZZ		41
#define AMP_Z_CLEAN			42
#define AMP_ACO_SIM			43

#define CAB_MIC_DYNAMIC		0
#define CAB_MIC_CONDENSER	1
#define CAB_MICPOS_CENTER	0
#define CAB_MICPOS_HALF		1
#define CAB_MICPOS_EDGE		2

#define MOD_PEDAL_UP		0
#define MOD_PEDAL_DOWN		1

#define MOD_CHORUS			0
#define MOD_STEREO_CHORUS	1
#define MOD_ENSEMBLE		2
#define MOD_MOD_DELAY		3
#define MOD_FLANGER			4
#define MOD_PITCH_SHIFT		5
#define MOD_PEDAL_PITCH		6
#define MOD_VIBE			7
#define MOD_STEP			8
#define MOD_DELAY			9
#define MOD_TAPE_ECHO		10
#define MOD_DYNAMIC_DELAY	11
#define MOD_DYNAMIC_FLANGER	12
#define MOD_MONOPITCH		13
#define MOD_HPS				14
#define MOD_PEDAL_MONOPITCH	15
#define MOD_CRY				16
#define MOD_REVERSE_DELAY	17
#define MOD_BEND_CHORUS		18
#define MOD_COMB_FILTER		19
#define MOD_AIR				20
#define MOD_Z_ECHO			21
#define MOD_X_FLANGER		22
#define MOD_X_STEP			23
#define MOD_Z_STEP			24
#define MOD_Z_PITCH			25
#define MOD_Z_MONOPITCH		26
#define MOD_Z_TALKING		27

#define DELAY_DELAY			0
#define DELAY_PINGPONG		1
#define DELAY_ECHO			2
#define DELAY_PINGPONG_ECHO	3
#define DELAY_ANALOG		4
#define DELAY_REVERSE_DELAY	5
#define DELAY_AIR			6

#define REVERB_HALL			0
#define REVERB_ROOM			1
#define REVERB_SPRING		2
#define REVERB_ARENA		3
#define REVERB_TILEDROOM	4
#define REVERB_MODERNSPRING	5
#define REVERB_EARLY_REFL	6
#define REVERB_MULTITAP		7
#define REVERB_PANDELAY		8
#define REVERB_PINGPONG_D	9
#define REVERB_PINGPONG_E	10
#define REVERB_AUTOPAN		11
#define REVERB_Z_DELAY		12
#define REVERB_Z_DIMENSION	13
#define REVERB_Z_TORNADO	14

#define TOTAL_FN_AMP_AB			0
#define TOTAL_FN_BPM_TAP		1
#define TOTAL_FN_DELAY_TAP		2
#define TOTAL_FN_HOLD_DELAY		3
#define TOTAL_FN_DELAY_MUTE		4
#define TOTAL_FN_BYPASS			5
#define TOTAL_FN_MUTE			6
#define TOTAL_FN_MANUAL_MODE	7
#define TOTAL_FN_COMP_ONOFF		8
#define TOTAL_FN_WAH_ONOFF		9
#define TOTAL_FN_EXTLOOP_ONOFF	10
#define TOTAL_FN_ZNR_ONOFF		11
#define TOTAL_FN_AMP_ONOFF		12
#define TOTAL_FN_EQ_ONOFF		13
#define TOTAL_FN_MOD_ONOFF		14
#define TOTAL_FN_DELAY_ONOFF	15
#define TOTAL_FN_REVERB_ONOFF	16

#define CONTROL_NOT_ASSIGNED	0
#define CONTROL_VOLUME			1
#define CONTROL_MAX				251

@interface G9ParameterInfo : NSObject

+ (G9RangeDomain *) rangeForPedalWithControlTargetIndex:(NSUInteger) controlTargetIndex;

+ (NSUInteger) controlTargetIndexForParameter:(NSUInteger)parameter
									  forType:(NSUInteger)typeIndex
								inModuleNamed:(NSString *)moduleName;

+ (G9RangeDomain *) rangeForParameter:(NSUInteger)parameter
							  forType:(NSUInteger)typeIndex
							 inModule:(NSString *)moduleName;

+ (NSUInteger) typeCountForModuleNamed:(NSString *)moduleName;

+ (NSUInteger) parameterCountForModuleNamed:(NSString *)moduleName;

+ (NSString *) nameForType:(NSUInteger)typeIndex
			 inModuleNamed:(NSString *)moduleName;

+ (NSString *) descriptionForType:(NSUInteger)typeIndex
					inModuleNamed:(NSString *)moduleName;

+ (NSString *) nameForParameter:(NSUInteger)parameter
						forType:(NSUInteger)typeIndex
				  inModuleNamed:(NSString *)moduleName;

+ (NSString *) descriptionForParameter:(NSUInteger)parameter
							   forType:(NSUInteger)typeIndex
						 inModuleNamed:(NSString *)moduleName;

+ (NSString *) labelForValue:(NSInteger)value
				forParameter:(NSUInteger)parameter
					 forType:(NSUInteger)typeIndex
			   inModuleNamed:(NSString *)moduleName;

+ (NSString *) descriptionForValue:(NSInteger)value
					  forParameter:(NSUInteger)parameter
						   forType:(NSUInteger)typeIndex
					 inModuleNamed:(NSString *)moduleName;

+ (NSString *) labelForControlTargetIndex:(NSUInteger)controlTargetIndex;

@end
