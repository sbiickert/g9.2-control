//
//  ZGRangeDomain.h
//  G9 Control
//
//  Created by Simon Biickert on 12/5/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface G9RangeDomain : NSObject

@property NSInteger minimum;
@property NSInteger maximum;

- (id) initWithMinimum:(NSInteger)minimum andMaximum:(NSInteger)maximum;
- (NSInteger) correctValueToClosestLegalValue:(NSInteger)value;

@end
