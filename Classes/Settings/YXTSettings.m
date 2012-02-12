//
//  YXTSettings.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-10.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTSettings.h"

@interface YXTSettings()
@property (nonatomic, retain) NSMutableDictionary* settingsDict;
@end


static YXTSettings* sInstance = nil;

@implementation YXTSettings

@synthesize settingsDict = mSettingsDict;

+(YXTSettings*) instance {
    if(sInstance == nil)
    {
        sInstance = [YXTSettings new];
    }
    return sInstance;
}

+(void)deleteInstance{
    [sInstance release];
    sInstance = nil;
}

-(id)init{
    if((self = [super init])){
        self.settingsDict = [NSMutableDictionary dictionaryWithCapacity:20];
        
		[self setDefaultTag:@"server-url" value:@"https://121.33.197.198:7091/"]; 
		//[self setDefaultTag:@"mobile-number" value:@"18001957019"];
		[self setDefaultTag:@"mobile-number" value:@"18918828387"];
		[self setDefaultTag:@"sign-code" value:@"e96e260410b4ea1a9cd227fae1041e30"];
    }
    return self;
}

-(NSString*)getSetting:(NSString*) key{
    return [self.settingsDict objectForKey:key];
}

-(void) setDefaultTag:(NSString*)tag value:(NSString*)value{
    [self.settingsDict setObject:value forKey:tag];
}

-(void)dealloc{
    self.settingsDict = nil;
    [super dealloc];
}


@end
