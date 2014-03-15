//
//  G9ModuleCollectionViewItem.h
//  G9 Control
//
//  Created by Simon Biickert on 2014-02-28.
//  Copyright (c) 2014 Simon Biickert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class G9Module;

@interface G9ModuleCollectionViewItem : NSCollectionViewItem

@property (readonly) G9Module* module;

@end
