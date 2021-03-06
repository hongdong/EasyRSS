//
//  FeedSceneModel.m
//  rssreader
//
//  Created by 朱潮 on 14-8-18.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "FeedSceneModel.h"
#import "DataCenter.h"
@interface FeedSceneModel ()
@end

@implementation FeedSceneModel

/**
 *   初始化加载SceneModel
 */
-(void)loadSceneModel{
    [super loadSceneModel];
    [self.action useCache];
    self.feedList = nil;
    self.dataArray = [NSMutableArray array];
    @weakify(self);
    _request = [FeedListRequest RequestWithBlock:^{  // 初始化请求回调
        @strongify(self)
        [self SEND_IQ_ACTION:self.request];
    }];
    
    
    [[RACObserve(self.request, state) //监控 网络请求的状态
      filter:^BOOL(NSNumber *state) { //过滤请求状态
          @strongify(self);
          return self.request.succeed;
      }]
     subscribeNext:^(NSNumber *state) {
         @strongify(self);
         NSError *error;
         self.feedList = [[FeedList alloc] initWithDictionary:[self.request.output objectForKey:@"Data"] error:&error];//Model的ORM操作，dictionary to object
     }];
}

@end
