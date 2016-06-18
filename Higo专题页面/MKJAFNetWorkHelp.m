//
//  MKJAFNetWorkHelp.m
//  Higo专题页面
//
//  Created by 宓珂璟 on 16/6/17.
//  Copyright © 2016年 宓珂璟. All rights reserved.
//

#import "MKJAFNetWorkHelp.h"
#import <AFNetworking.h>
#import <AFHTTPSessionManager.h>
#import <MJExtension.h>
#import "HigoModel.h"

@implementation MKJAFNetWorkHelp

+ (MKJAFNetWorkHelp *)shareRequest
{
    static MKJAFNetWorkHelp *mkjNet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mkjNet = [[MKJAFNetWorkHelp alloc] init];
    });
    return mkjNet;
}

- (void)MKJGETRequest:(NSString *)requestURL page:(NSInteger)page parameters:(NSDictionary *)parameters succeed:(completionBlock)succeedBlock failure:(completionBlock)failureBlock
{
    // AF3.0的方法
    AFHTTPSessionManager *man = [AFHTTPSessionManager manager];
    man.responseSerializer = [AFJSONResponseSerializer serializer];
    man.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    
    [man POST:requestURL parameters:@{
                                      @"category_id" : @"48",
                                      @"app" : @"higo",
                                      @"category_source" : @"1",
                                      @"client_id" : @"1",
                                      @"cver" : @"5.1.0",
                                      @"device_id" : @"h_13aa73608eac4f13a3a37987678ed986",
                                      @"device_model" : @"iPhone 6S Plus",
                                      @"device_token" : @"c8b128363664e6feda0bac9ae1931c53392994308e455ee1d481dc1108883402",
                                      @"device_version" : @"9.3.2",
                                      @"idfa" : @"2FF88C7F-0756-427B-A2A3-B7FB449D7043",
                                      @"open_udid" : @"cdec8d86d9b086f705183232c1f607a106fa42b3",
                                      @"p" : [NSString stringWithFormat:@"%ld",page],
                                      @"package_type" : @"1",
                                      @"qudaoid" : @"10000",
                                      @"uuid" : @"486b8b8fd7b0b02d3852841bcdf6bba6",
                                      @"ratio" : @"1242*2208",
                                      @"size" : @"30",
                                      @"ver" : @"0.8",
                                      @"via" : @"iphone"
                                      
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        // MJExtension的方法
        [HigoList mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"category_list" : @"CategoryModel",@"goods_list":@"GoodsModel"};
        }];
        
        // 一句话变身为Model
        HigoList *list = [HigoList mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
        // 回调
        if (succeedBlock) {
            succeedBlock(nil,list);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error,nil);
        }
    }];
}


@end
