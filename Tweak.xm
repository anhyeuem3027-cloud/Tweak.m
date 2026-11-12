#import <Foundation/Foundation.h>

%hook NSURLSession

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    
    NSString *urlString = [[request URL] absoluteString];
    
    if ([urlString containsString:@"check"] || [urlString containsString:@"license"] || [urlString containsString:@"key"] || [urlString containsString:@"api"]) {
        NSDictionary *dict = @{@"status": @"success", @"valid": @YES};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
        NSHTTPURLResponse *resp = [[NSHTTPURLResponse alloc] initWithURL:[request URL] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:@{@"Content-Type": @"application/json"}];
        
        return [self dataTaskWithRequest:request completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
            completionHandler(data, resp, nil);
        }];
    }
    
    return %orig;
}

%end
