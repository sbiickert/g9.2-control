//
//  ZGValue.h
//  G9 Control
//
//  Created by Simon Biickert on 12/5/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface G9Value : NSObject

@property NSInteger value;
@property (nonatomic, retain) NSString *label;

- (id) initWithValue:(NSInteger)value andLabel:(NSString *)label;
@end
