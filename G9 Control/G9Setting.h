//
//  Setting.h
//  G9 Control
//
//  Created by Simon Biickert on 11/28/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface G9Setting : NSObject <NSCoding>

@property (readwrite) BOOL enabled;
@property (readwrite) NSUInteger type;
@property (readwrite) NSUInteger param1;
@property (readwrite) NSUInteger param2;
@property (readwrite) NSUInteger param3;
@property (readwrite) NSUInteger param4;
@property (readwrite) NSUInteger param5;
@property (readwrite) NSUInteger param6;

- (void) copyValuesTo:(G9Setting *)other;
@end
