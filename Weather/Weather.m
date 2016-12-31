//
//  Weather.m
//  Weather
//
//  Created by F&Easy on 16/10/11.
//  Copyright © 2016年 F&Easy. All rights reserved.
//

#import "Weather.h"
#import "FutureWeather.h"

@interface Weather()

@property(nonatomic,strong) NSDictionary *weaherDict;

@end

@implementation Weather
//创建实例对象的构造方法，通过网络请求的数据来创建天气对象
-(instancetype)initWithWeatherData:(NSData *)weatherData{
    self = [super init];
    if (self) {
        //weatherData 是个二进制,看不出是类型，把二进制数据转换为字符串
        [self dealWithData:weatherData];
        //筛选用于展示的数据
        //将WeatherDict 中的数据赋值给weather对象
        
        //从字典中取出的值都是对象类型，int是基本类型，类型不匹配
        self.cityId = [[self.weaherDict valueForKey:@"cityid"] intValue];
        
        self.cityName = [self.weaherDict valueForKey:@"city"];
        self.week = [self.weaherDict valueForKey:@"week"];
        self.date_y = [self.weaherDict valueForKey:@"date_y"];
        self.pm = [self.weaherDict valueForKey:@"pm"];
        self.pmLevel = [self.weaherDict valueForKey:@"pm-level"];
        self.weather = [self.weaherDict valueForKey:@"img_title_single"];
        self.temp = [self.weaherDict valueForKey:@"temp"];
        self.wind = [self.weaherDict valueForKey:@"wd"];
        self.windLevel = [self.weaherDict valueForKey:@"ws"];
        
        //初始化数组
        self.futureWeatherArray = [[NSMutableArray alloc]init];
        for (int i = 1; i < 7; i++) {
            NSString *futureWeatherString = [self.weaherDict valueForKey:[NSString stringWithFormat:@"weather%d",i]];
            NSString *futureTempString = [self.weaherDict valueForKey:[NSString stringWithFormat:@"temp%d",i]];
            NSString *futureWindString = [self.weaherDict valueForKey:[NSString stringWithFormat:@"wind%d",i]];
            
            NSString *futureWeekString = [self countWeekString:i];
            
            //创建未来天气对象添加入数组
            FutureWeather *futureWeather = [[FutureWeather alloc]initWithWeather:futureWeatherString temp:futureTempString wind:futureWindString week:futureWeekString];
            [self.futureWeatherArray addObject:futureWeather];
        }
    
    }
    return self;
}


-(NSString *)countWeekString:(int) index{
    
    NSArray *weekStringArray = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    
    //计算当天在数组中的下标
    
    NSUInteger currentWeekIndex = [weekStringArray indexOfObject:self.week];
    
    //计算未来第index天在数组中的下标
    NSUInteger futureWeekIndex = currentWeekIndex + index;
    
    //处理下标越界
    if (futureWeekIndex > 6) {
        futureWeekIndex = futureWeekIndex-7;
    }
    
    
    return weekStringArray[futureWeekIndex];
}

-(void)dealWithData:(NSData *)data{
    //把data数据装换为字符串
    NSString *resultString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
   
    //
    NSInteger startIndex = [resultString rangeOfString:@"("].location;
    NSInteger endIndex = [resultString rangeOfString:@")"].location;
    
    //NSRange有两个属性location（开始位置），length（长度）
    NSString *resultJsonString = [resultString substringWithRange:NSMakeRange(startIndex+1, endIndex-startIndex-1)];
    NSLog(@"%@",resultJsonString);
    
    //把json转化为字典
    //先转化为二进制
    
    NSData *jsonData = [resultJsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    //
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    //将结果设为成员变量，方便使用
    self.weaherDict = [resultDict valueForKey:@"weatherinfo"];
    
    
}

@end
