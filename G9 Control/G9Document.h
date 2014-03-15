//
//  G9Document.h
//  G9 Control
//
//  Created by Simon Biickert on 12/24/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class G9ModuleView;

@interface G9Document : NSPersistentDocument

@property (weak) IBOutlet NSCollectionView *collectionView;
@property (retain, nonatomic) IBOutlet NSCollectionViewItem *collectionViewItem;

@property (retain, nonatomic) NSArrayController *pedal1TargetsController;
@property (retain, nonatomic) NSArrayController *pedal2VTargetsController;
@property (retain, nonatomic) NSArrayController *pedal2HTargetsController;

@property (retain, nonatomic) NSArrayController *arrmTargetsController;
@property (retain, nonatomic) NSArrayController *arrmWaveController;
@property (retain, nonatomic) NSArrayController *arrmSyncController;

@end
