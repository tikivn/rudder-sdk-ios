//
//  RSMessageHandler.swift
//  Rudder
//
//  Created by Pallab Maiti on 27/08/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation

class RSMessageHandler {
    let factoryDumpManager = RSFactoryDumpManager()
    
    func dumpMessage(_ message: RSMessage) {
        if message.type == .identify {
            if let options = message.option, let externalIds = options.externalIds {
                RSClient.shared.eventManager.cachedContext?.updateExternalIds(externalIds)
            }
            message.context = RSClient.shared.eventManager.cachedContext
        }
        guard RSClient.shared.eventManager.isSDKEnabled == true else {
            fatalError("SDK is not enabled")
        }
        if message.integrations?.isEmpty == true, let options = RSClient.shared.eventManager.options, let integrations = options.integrations, !integrations.isEmpty {
            message.integrations = integrations            
        }
        message.isAll = true
        factoryDumpManager.makeFactoryDump(message)
        /*
         NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[message dict] options:0 error:nil];
         NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
         
         [RSLogger logDebug:[[NSString alloc] initWithFormat:@"dump: %@", jsonString]];
         
         unsigned int messageSize = [RSUtils getUTF8Length:jsonString];
         if (messageSize > MAX_EVENT_SIZE) {
             [RSLogger logError:[NSString stringWithFormat:@"dump: Event size exceeds the maximum permitted event size(%iu)", MAX_EVENT_SIZE]];
             return;
         }
         
         [self->dbpersistenceManager saveEvent:jsonString];
         */
    }
}
