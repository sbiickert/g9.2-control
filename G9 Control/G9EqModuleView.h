//
//  G9EqModuleView.h
//  G9 Control
//
//  Created by Simon Biickert on 2014-03-02.
//  Copyright (c) 2014 Simon Biickert. All rights reserved.
//

#import "G9ModuleView.h"

@interface G9EqModuleView : G9ModuleView

@property (weak) IBOutlet NSTextField *paramLabel1;
@property (weak) IBOutlet NSTextField *paramLabel2;
@property (weak) IBOutlet NSTextField *paramLabel3;
@property (weak) IBOutlet NSTextField *paramLabel4;
@property (weak) IBOutlet NSTextField *paramLabel5;
@property (weak) IBOutlet NSTextField *paramLabel6;

@property (weak) IBOutlet NSTextField *paramValueLabel1;
@property (weak) IBOutlet NSTextField *paramValueLabel2;
@property (weak) IBOutlet NSTextField *paramValueLabel3;
@property (weak) IBOutlet NSTextField *paramValueLabel4;
@property (weak) IBOutlet NSTextField *paramValueLabel5;
@property (weak) IBOutlet NSTextField *paramValueLabel6;

@property (weak) IBOutlet NSSlider *paramSlider1;
@property (weak) IBOutlet NSSlider *paramSlider2;
@property (weak) IBOutlet NSSlider *paramSlider3;
@property (weak) IBOutlet NSSlider *paramSlider4;
@property (weak) IBOutlet NSSlider *paramSlider5;
@property (weak) IBOutlet NSSlider *paramSlider6;

@end
