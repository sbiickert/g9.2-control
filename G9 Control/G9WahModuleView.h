//
//  G9CompModuleView.h
//  G9 Control
//
//  Created by Simon Biickert on 2014-03-01.
//  Copyright (c) 2014 Simon Biickert. All rights reserved.
//

#import "G9ModuleView.h"

@interface G9WahModuleView : G9ModuleView

@property (retain, nonatomic) IBOutlet NSArrayController *typeArrayController;
@property (weak) IBOutlet NSPopUpButton *typePopUp;

@property (weak) IBOutlet NSTextField *paramLabel1;
@property (weak) IBOutlet NSTextField *paramLabel2;
@property (weak) IBOutlet NSTextField *paramLabel3;
@property (weak) IBOutlet NSTextField *paramLabel4;

@property (weak) IBOutlet NSTextField *paramValueLabel1;
@property (weak) IBOutlet NSTextField *paramValueLabel2;
@property (weak) IBOutlet NSTextField *paramValueLabel3;
@property (weak) IBOutlet NSTextField *paramValueLabel4;

@property (weak) IBOutlet NSSlider *paramSlider1;
@property (weak) IBOutlet NSSlider *paramSlider2;
@property (weak) IBOutlet NSSlider *paramSlider3;
@property (weak) IBOutlet NSSlider *paramSlider4;

@property (retain, nonatomic) NSMutableDictionary *popUpArrayControllers;
@property (weak) IBOutlet NSPopUpButton *paramPopUp1;
@property (weak) IBOutlet NSPopUpButton *paramPopUp2;
@property (weak) IBOutlet NSPopUpButton *paramPopUp3;
@property (weak) IBOutlet NSPopUpButton *paramPopUp4;

@end
