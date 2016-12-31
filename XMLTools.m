//
//  XMLTools.m
//  Weather
//
//  Created by F&Easy on 16/10/12.
//  Copyright © 2016年 F&Easy. All rights reserved.
//

#import "XMLTools.h"

@interface XMLTools ()<NSXMLParserDelegate>

@property(nonatomic,strong)NSString *filePath;

@property(nonatomic,strong)NSMutableArray *valueArray;

@property(nonatomic,strong)NSMutableString *elementValueString;

@property(nonatomic,strong)NSMutableDictionary *resultDict;

@end




@implementation XMLTools

- (instancetype)initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if (self) {
        self.filePath = filePath;
        [self analysisXMLFile];
    }
    return self;
}

-(void)analysisXMLFile{
    //读出文件的内容
    NSData *fileData = [[NSData alloc]initWithContentsOfFile:self.filePath];
    
    //分析数据
    
//        通过NSDictionary键值对来保存XML文件数据   key --- value
//        把城市名字作为键，城市的id作为值
//        在使用时通过城市名字就能从字典中获取城市的id
//        通过字典的allKeys方法，可以取到所有城市的名字，方便在实现城市名称列表中使用

    //XML文件通过NSXMLparser解析器来解析
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:fileData];
    [parser setDelegate:self];
    [parser parse];
  
    
    
}


-(NSMutableDictionary *)getResultDict{
    return self.resultDict;
}

#pragma mark NSXMLParserDelegate

/*
 1->2->3->4->
 ......
 ->2->3->4->
 5
 
 */
//（1）当XML文件开始解析是系统调用方法，一般做一些变量初始化工作
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    self.valueArray = [[NSMutableArray alloc]init];
    self.resultDict = [[NSMutableDictionary alloc]init];
}
//（2）当XML解析器解析到一个开始标签是系统调用的方法
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    
}
//（3）当XML解析器，解析到一个值时调用的方法
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    self.elementValueString = [[NSMutableString alloc]init];
    
    //元素的值保存
    [self.elementValueString appendString:string];
    
}


//（4）当XMl解析器，解析到一个结束标签时调用的方法
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    
    NSString *valueString = [[NSString alloc]initWithString:self.elementValueString];
    //判断
    if ([elementName isEqualToString:@"key"]) {
        [self.valueArray addObject:valueString];
    }
    
    if ([elementName isEqualToString:@"string"]) {
        [self.valueArray addObject:valueString];
    }
    
}

//（5）当XML文件解析结束时调用的方法（整理数据结果）
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    
    for (int i = 0; i < self.valueArray.count; i++) {
        NSString *cityName = self.valueArray[i];
        NSString *cityCode = self.valueArray[i+1];
        
        [self.resultDict setValue:cityCode forKey:cityName];
        
        i++;
    }
    
}


@end
