//
//  G9ArrayController.h
//  G9 Control
//
//  Created by Simon Biickert on 12/28/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define G9_PATCH_DND_TYPE	@"G9_PATCH_DND_TYPE"

@interface G9PatchArrayController : NSArrayController <NSTableViewDataSource>

@property (nonatomic, weak) IBOutlet NSTableView *tableView;

@end
