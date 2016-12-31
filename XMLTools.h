//
//  XMLTools.h
//  Weather
//
//  Created by F&Easy on 16/10/12.
//  Copyright © 2016年 F&Easy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLTools : NSObject

- (instancetype)initWithFilePath:(NSString *)filePath;
-(NSMutableDictionary *)getResultDict;
@end
