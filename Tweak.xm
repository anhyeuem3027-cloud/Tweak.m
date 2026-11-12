#import <Foundation/Foundation.h>

// 1. Hook vào các lớp hoặc phương thức phổ biến của menu hack (như kiểm tra trạng thái kích hoạt)
%subclass LicenseManager
- (BOOL)isLicenseActivated {
    return YES; // Luôn trả về giá trị ĐÃ KÍCH HOẠT
}
- (BOOL)checkKeyValid:(id)arg1 {
    return YES;
}
%end

// 2. Chặn và giả lập phản hồi HTTP nếu menu hack gọi API check key trực tiếp
%hook NSURLSession

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    
    NSString *urlString = [[request URL] absoluteString];
    
    // Nếu phát hiện request liên quan đến việc check key, license hoặc api xác thực
    if ([urlString containsString:@"api"] || [urlString containsString:@"license"] || [urlString containsString:@"key"] || [urlString containsString:@"check"] || [urlString containsString:@"auth"]) {
        
        // Tạo JSON giả lập báo thành công 100% để menu tự động mở
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

// 3. Hàm khởi tạo khi tệp .dylib được tiêm vào game
__attribute__((constructor))
static void NoKeyBypassInit(void) {
    @autoreleasepool {
        NSLog(@"[NoKeyBypass] Tệp dylib đã được tiêm và vô hiệu hóa key thành công!");
    }
}
