// File created from ScreenTemplate
// $ createScreen.sh Threads/ThreadList ThreadList
/*
 Copyright 2021 New Vector Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

protocol ThreadListCoordinatorDelegate: AnyObject {
    func threadListCoordinatorDidLoadThreads(_ coordinator: ThreadListCoordinatorProtocol)
    func threadListCoordinatorDidSelectThread(_ coordinator: ThreadListCoordinatorProtocol, thread: MXThread)
    func threadListCoordinatorDidSelectRoom(_ coordinator: ThreadListCoordinatorProtocol, roomId: String, eventId: String)
    func threadListCoordinatorDidCancel(_ coordinator: ThreadListCoordinatorProtocol)
}

/// `ThreadListCoordinatorProtocol` is a protocol describing a Coordinator that handle thread list navigation flow.
protocol ThreadListCoordinatorProtocol: Coordinator, Presentable {
    var delegate: ThreadListCoordinatorDelegate? { get }
}
