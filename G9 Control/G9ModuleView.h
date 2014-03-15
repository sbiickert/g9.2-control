//
//  G9PatchOverviewView.h
//  G9 Control
//
//  Created by Simon Biickert on 12/28/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define MODULE_LABEL_TAG		100
#define MODULE_TYPE_TAG			101

#define MODULES_REORDERED		@"G9 Modules reordered"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@class G9Module;

@interface G9ModuleView : NSView

- (IBAction)toggleOnOffButton:(id)sender;
@property (weak) IBOutlet NSButton *onOffButton;
@property (readwrite, assign) NSString* onOffButtonTitle;

@property (retain, nonatomic) G9Module *module;

@end
