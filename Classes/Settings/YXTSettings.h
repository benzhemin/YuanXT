//
//  YXTSettings.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-10.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface YXTSettings : NSObject {
@private
    NSMutableDictionary* mSettingsDict;
}

+(YXTSettings*) instance;
+(void)deleteInstance;


-(NSString*)getSetting:(NSString*) key;
-(void) setDefaultTag:(NSString*)tag value:(NSString*)value;

@end