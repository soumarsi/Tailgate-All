//
//  TGGlobalClass.m
//  Taligate
//
//  Created by Soumarsi Kundu on 23/04/15.
//  Copyright (c) 2015 esolz. All rights reserved.
//

#import "TGGlobalClass.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>

//#define App_Domain_Url @"http://esolz.co.in/lab6/tailgate/web_service/"
#define App_Domain_Url @"http://tailgategroup.com/web_service/"

#ifdef DEBUG

#define DebugLog(...) NSLog(__VA_ARGS__)

#else

#define DebugLog(...) while(0)

#endif

@implementation TGGlobalClass
{
    Urlresponceblock _responce;
    NSString *check;
}

-(void)GlobalDict:(NSString *)parameter Withblock:(Urlresponceblock)responce
{
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",App_Domain_Url,parameter]];
    DebugLog(@"URL---- %@",[NSString stringWithFormat:@"%@%@",App_Domain_Url,parameter]);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    connection=nil;
    _responce=[responce copy];
 
}
-(NSDictionary *)saveStringDict:(NSString *)parameter savestr:(NSString *)parametercheck saveimagedata:(NSData *)imagedata
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",App_Domain_Url,parameter]]];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    
    if ( imagedata.length > 0)
        
    {
        NSLog(@"Uploading..... %@",parameter);
        NSString *boundary = [NSString stringWithFormat:@"%0.9u",arc4random()];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"screenshot\"; filename=\".jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imagedata];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
    }
     NSURLResponse *response = nil;
    NSError *error;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *result =  [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];

    return result;
    
    
}
-(void)GlobalStringDict:(NSString *)parameter Globalstr:(NSString *)parametercheck Withblock:(Urlresponceblock)responce
{
    
   
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",App_Domain_Url,parameter]];
    DebugLog(@"URL---- %@",[NSString stringWithFormat:@"%@%@",App_Domain_Url,parameter]);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    check = parametercheck;
    connection=nil;
    _responce=[responce copy];
    
}
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    responseData = [[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [responseData appendData:data];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    NSLog(@"Did Fail");
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([check isEqual: @"string"])
    {
    
    id result = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        _responce(result,nil);
    
    }
    else
    {
    
        DebugLog(@"GLOBAL CLASS ELSE------");
        id result=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        _responce(result,nil);

   }


}


-(void)Userdict:(NSDictionary *)userdetails
{
    UserData = [[NSUserDefaults alloc]init];
    
    [UserData setObject:[userdetails objectForKey:@"user_id"] forKey:@"userid"];
    [UserData setObject:[userdetails objectForKey:@"first_name"] forKey:@"firstname"];
    [UserData setObject:[userdetails objectForKey:@"last_name"] forKey:@"lastname"];
    [UserData setObject:[userdetails objectForKey:@"email"] forKey:@"email"];
    [UserData setObject:[userdetails objectForKey:@"type"] forKey:@"type"];
    [UserData setObject:@"YES" forKey:@"Logout"];
    [UserData setObject:@"YES" forKey:@"Remember"];
    [UserData synchronize];
}
- (BOOL)connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

-(void)parameterstring:(NSString *)parameter withblock:(Urlresponceblock)responce
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",App_Domain_Url,parameter]];
    DebugLog(@"URL---- %@",[NSString stringWithFormat:@"%@%@",App_Domain_Url,parameter]);
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                            text = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                            responce(text,nil);
                                                        }
                                                  
                                                    }];

    [dataTask resume];
    
  
}

@end
