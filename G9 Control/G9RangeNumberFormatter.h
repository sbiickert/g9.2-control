//
//  G9RangeNumberFormatter.h
//  G9 Control
//
//  Created by Simon Biickert on 2014-03-16.
//  Copyright (c) 2014 Simon Biickert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface G9RangeNumberFormatter : NSNumberFormatter

@property (nonatomic, readwrite) NSInteger integerMinimum;
@property (nonatomic, readwrite) NSInteger integerMaximum;

- (id) initWithMinimum:(NSInteger)minimum andMaximum:(NSInteger)maximum;
- (NSString *) correctedStringForInputString:(NSString *)inputString;

@end
