//
//  ZGValueDomain.h
//  G9 Control
//
//  Created by Simon Biickert on 12/5/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "G9RangeDomain.h"
#import "G9Value.h"

@interface G9ValueDomain : G9RangeDomain

@property (readonly) NSUInteger valueCount;
@property (nonatomic, retain, readonly) NSArray *values;

- (G9Value *) valueAtIndex:(NSUInteger)index;
- (void) addValue:(G9Value *)value;

@end
