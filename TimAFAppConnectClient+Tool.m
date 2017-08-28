//
//  AFAppConnectClient.m
//  CarMaintenance
//
//  Created by S.K. on 15-1-5.
//  Copyright (c) 2015年 S.K. All rights reserved.
//

#import "TimAFAppConnectClient+Tool.h"
#import <EasyIOS/NSObject+EasyJSON.h>

#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "AESCipher.h"
#import "Config.h"

#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )


@interface TimAFAppConnectClient() <NSURLConnectionDelegate, NSURLSessionTaskDelegate, NSURLConnectionDataDelegate, NSURLSessionDataDelegate>
@property (strong,nonatomic) NSCache *netStateCache;

@end

@implementation TimAFAppConnectClient(Tool)
+(void)load
{
    [super load];
    
    [TimAFAppConnectClient setBaseUrl:APPNetWorkAddress ];
    
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
+ ( TimAFAppConnectClient * _Nonnull )sharedClient
{
    static TimAFAppConnectClient *shareNetworkClient;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
        shareNetworkClient = [[TimAFAppConnectClient alloc] initWithBaseURL:[NSURL URLWithString:[Config sharedInstance].appNetWorkAddress]];
        shareNetworkClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        shareNetworkClient.requestSerializer.timeoutInterval = 40;
        shareNetworkClient.responseSerializer = [AFJSONResponseSerializer serializer];
        
        shareNetworkClient.responseSerializer.acceptableContentTypes =[NSSet setWithArray:@[@"text/html",@"text/plain",@"application/json"]];
        
        //        shareNetworkClient.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
        
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        
//        NSData *certificateData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"https.www.taoqian123.com" ofType:@"cer"]];
//        securityPolicy.pinnedCertificates = [NSSet setWithObject: certificateData];
        
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;
        
        shareNetworkClient.securityPolicy = [AFSecurityPolicy defaultPolicy];
        
        
        
        shareNetworkClient.netStateCache = [NSCache new];
        
        [shareNetworkClient setSucessCode:1 statusCodeKey:@"status" msgKey:@"info" responseDataKey:@"data"];
        
        
    });
    
    return shareNetworkClient;
}


- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
//    
//    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
//    NSURLCredential *credential = nil;
//    
//    disposition = NSURLSessionAuthChallengeUseCredential;
//    credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//    completionHandler(disposition, credential);
//    return;
    
    
    NSURLSessionTask *task = nil;
    
    [self URLSession:session task:task didReceiveChallenge:challenge completionHandler:completionHandler];
    
}
#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler {
    if (!challenge) {
        return;
    }
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    /*
     * 获取原始域名信息。
     */
    BOOL useDNS = NO;
    NSString *host = [[task.originalRequest allHTTPHeaderFields] objectForKey:@"host"];
    if(!host){
        host = self.baseURL.host;
    }else{
        useDNS = YES;
    }
    
    if (!host) {
        host = task.originalRequest.URL.host;
    }
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (useDNS == NO) {
            if ([self.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:host]) {
                disposition = NSURLSessionAuthChallengeUseCredential;
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            } else {
                disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            }
        }else{
            if ([self evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:host]) {
                disposition = NSURLSessionAuthChallengeUseCredential;
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            } else {
                disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            }
        }
        
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    // 对于其他的challenges直接使用默认的验证方案
    completionHandler(disposition, credential);
}


- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString *)domain {
    /*
     * 创建证书校验策略
     */
    NSMutableArray *policies = [NSMutableArray array];
    if (domain) {
        [policies addObject:(__bridge_transfer id) SecPolicyCreateSSL(true, (__bridge CFStringRef) domain)];
    } else {
        [policies addObject:(__bridge_transfer id) SecPolicyCreateBasicX509()];
    }
    /*
     * 绑定校验策略到服务端的证书上
     */
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef) policies);
    /*
     * 评估当前serverTrust是否可信任，
     * 官方建议在result = kSecTrustResultUnspecified 或 kSecTrustResultProceed
     * 的情况下serverTrust可以被验证通过，https://developer.apple.com/library/ios/technotes/tn2232/_index.html
     * 关于SecTrustResultType的详细信息请参考SecTrust.h
     */
    SecTrustResultType result;
    SecTrustEvaluate(serverTrust, &result);
    return (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
}
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block

                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return  [self POST:URLString parameters:parameters constructingBodyWithBlock:block
          allowHTTPDNS:YES
              progress:uploadProgress success:success failure:failure];
    
}
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                  allowHTTPDNS:(BOOL)allowHTTPDNS
                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    
    NSNumber *hostNum = [self.netStateCache objectForKey:self.baseURL.host];
//    hostNum = @1;
    if(hostNum && [hostNum integerValue] > 2 && allowHTTPDNS ){
        ///dns
        NSURL *url = request.URL;
        NSString *originalUrl = url.absoluteString;
        
        HttpDnsService *httpdns = [HttpDnsService sharedInstance];
        // 同步接口获取IP
        NSString* ip = [httpdns getIpByHost:url.host];
        //    ip = @"120.27.142.86";
        
        if (ip) {
            // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
            NSRange hostFirstRange = [originalUrl rangeOfString: url.host];
            if (NSNotFound != hostFirstRange.location) {
                NSString* newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
                //            request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl]];
                request.URL =[NSURL URLWithString:newUrl];
                // 设置请求HOST字段
                [request setValue:url.host forHTTPHeaderField:@"host"];
            }
        }
        
    }
    
    
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if(error){
                
                if (allowHTTPDNS == NO) {
                    if (failure) {
                        failure(task, error);
                    }
                    return ;
                }
                
                
                
                if (error.code <= -1200 && error.code >= -2000) {
                    ///此服务器的证书无效。您可能正在连接到一个伪装成“api.taoqian123.com”的服务器，这会威胁到您的机密信息的安全。
                    if (failure) {
                        failure(task, error);
                    }
                    return ;
                }
                
                
                
                
                
                NSNumber *hostNum = [self.netStateCache objectForKey:self.baseURL.host];
                if(hostNum )
                {
                    hostNum = @([hostNum integerValue]+1);
                }else{
                    hostNum = @1;
                }
                
                [self.netStateCache setObject:hostNum forKey:self.baseURL.host];
                
                ///失败3次就不 repeat 网络请求
                if(hostNum.integerValue > 3) {
                    if (failure) {
                        failure(task, error);
                    }
                }else{
                    if([self.baseURL.host isEqualToString:task.originalRequest.URL.host] ){
                        //REPET
                        
                        [self POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
                        
                    }else{
                        if (failure) {
                            failure(task, error);
                        }
                    }
                }
                
                
                
                
            }else{
                if (failure) {
                    failure(task, error);
                }
            }
            
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    
    [task resume];
    
    return task;
}

-(NSMutableDictionary *)addBaseInfo:(NSDictionary *)info
{
    
    NSMutableDictionary *mParam = [[NSMutableDictionary alloc] initWithDictionary:info];
    [mParam setObject:@([NSDate timeIntervalSinceReferenceDate]).stringValue forKey:@"t"];
    
    
    NSArray *allkey = [mParam allKeys];
    [allkey sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return  [obj1 compare:obj2];
    }];
    
    NSArray *allValues = [mParam allValues];
    [allValues sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *string1 = [NSString stringWithFormat:@"%@",obj1];
        NSString *string2 = [NSString stringWithFormat:@"%@",obj2];
        
        return  [string1 compare:string2];
        
    }];
    
    NSString *string = [[allkey componentsJoinedByString:@"+"] stringByAppendingString:[allValues componentsJoinedByString:@"-"]];
    
    NSString *md5 = [string MD5];
    
    [mParam setObject:md5 forKey:@"time"];

    return mParam;
    
}
#pragma clang diagnostic pop

static const void *NetStateDictKey  = &NetStateDictKey;
-(void)setNetStateCache:(NSCache *)netStateCache
{
    objc_setAssociatedObject(self, NetStateDictKey, netStateCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC  );
    
    
}
-(NSCache *)netStateCache
{
   return  objc_getAssociatedObject(self, NetStateDictKey);
    
}

@end
