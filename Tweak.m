#import <Foundation/Foundation.h>

%hook NSURLSession

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    
    NSString *urlString = [[request URL] absoluteString];
    
    // Kiểm tra nếu request trỏ tới domain hoặc API check key của menu hack
    if ([urlString containsString:@"api"] || [urlString containsString:@"license"] || [urlString containsString:@"key"] || [urlString containsString:@"check"]) {
        
        // Tạo chuỗi JSON giả lập phản hồi thành công tuyệt đối
        NSDictionary *fakeDict = @{
            @"status": @"success",
            @"code": @200,
            @"valid": @YES,
            @"message": @"Key activated successfully"
        };
        
        NSData *fakeData = [NSJSONSerialization dataWithJSONObject:fakeDict options:0 error:nil];
        NSHTTPURLResponse *fakeResponse = [[NSHTTPURLResponse alloc] initWithURL:[request URL] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:@{@"Content-Type": @"application/json"}];
        
        return [self dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            completionHandler(fakeData, fakeResponse, nil];
        }];
    }
    
    return %orig;
}

%end

__attribute__((constructor))
static void EducationalTweakInitialize(void) {
    @autoreleasepool {
        NSLog(@"[EducationalTweak] Dynamic library loaded and active.");
    }
}
