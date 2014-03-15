//
//  G9Module.h
//  G9 Control
//
//  Created by Simon Biickert on 1/4/2014.
//  Copyright (c) 2014 Simon Biickert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class G9Patch;
@class G9Setting;

@interface G9Module : NSObject

@property (nonatomic, retain) NSString *moduleName;
@property (nonatomic, weak) G9Patch *patch;
@property (readonly) G9Setting *setting;

- (id) initWithModuleName:(NSString *)name patch:(G9Patch *)patch;

@end
