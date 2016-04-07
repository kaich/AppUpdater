# AppUpdater
desktop app updater 

电脑端程序更新简易脚本！

mac app为例配合如下代码：

	-(void) checkUpdate
	{
	    NSURL * url = [NSURL URLWithString:@"http://192.168.1.191:3000/app/9/check_update"];
	    NSURLSessionTask * task  = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
	        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
	        if (dic) {
	            NSString * downloadUrl = dic[@"download_path"];
	            
	            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
	                [self updateApp:downloadUrl];
	            });
	        }
	    }];
	    [task resume];
	}
	
	
移动脚本文件
	
	-(void) dealUpdate
	{
	    NSString * sPath = [[NSBundle mainBundle] pathForResource:@"mac_app_updater" ofType:@"sh"];
	    if (sPath) {
	        NSString * tPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/mac_app_updater.sh"];
	        if ([[NSFileManager defaultManager] fileExistsAtPath:tPath]) {
	            [[NSFileManager defaultManager] removeItemAtPath:tPath error:nil];
	        }
	        [[NSFileManager defaultManager] copyItemAtPath:sPath toPath:tPath error:nil];
	    }
	}
	

调用脚本更新程序	

	-(void) updateApp:(NSString *) downloadUrl
	{
	    dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
	        
	        NSString * tPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/mac_app_updater.sh"];
	        NSString * command = [NSString stringWithFormat:@"sh %@ %@",tPath,downloadUrl];
	        const char * cc = [command cStringUsingEncoding:NSUTF8StringEncoding];
	        system(cc);
	            
	    });
	    
	}