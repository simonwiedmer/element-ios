// File created from ScreenTemplate
// $ createScreen.sh Spaces/SpaceMembers/MemberList ShowSpaceMemberList
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

protocol ShowSpaceMemberListCoordinatorDelegate: AnyObject {
    func showSpaceMemberListCoordinator(_ coordinator: ShowSpaceMemberListCoordinatorType, didSelect member: MXRoomMember, from sourceView: UIView?)
    func showSpaceMemberListCoordinatorDidCancel(_ coordinator: ShowSpaceMemberListCoordinatorType)
}

/// `ShowSpaceMemberListCoordinatorType` is a protocol describing a Coordinator that handle key backup setup passphrase navigation flow.
protocol ShowSpaceMemberListCoordinatorType: Coordinator, Presentable {
    var delegate: ShowSpaceMemberListCoordinatorDelegate? { get }
}
