#import <Foundation/Foundation.h>

%hook NSURLSession

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    
    NSString *urlString = [[request URL] absoluteString];
    
    // Nếu ứng dụng/menu hack gửi request kiểm tra key, license hoặc api xác thực
    if ([urlString containsString:@"api"] || [urlString containsString:@"license"] || [urlString containsString:@"key"] || [urlString containsString:@"check"] || [urlString containsString:@"auth"]) {
        
        // Tạo dữ liệu JSON giả lập báo thành công tuyệt đối
        NSDictionary *fakeDict = @{
            @"status": @"success",
            @"code": @200,
            @"valid": @YES,
            @"message": @"Bypassed successfully"
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
static void NoKeyBypassInit(void) {
    @autoreleasepool {
        NSLog(@"[NoKeyBypass] Dylib loaded and active successfully!");
    }
}
