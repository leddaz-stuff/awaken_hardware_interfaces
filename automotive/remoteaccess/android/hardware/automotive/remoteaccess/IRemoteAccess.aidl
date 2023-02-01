/*
 * Copyright (C) 2022 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package android.hardware.automotive.remoteaccess;

import android.hardware.automotive.remoteaccess.ApState;
import android.hardware.automotive.remoteaccess.IRemoteTaskCallback;

/**
 * Interface representing a remote wakeup client.
 *
 * A wakeup client is a binary outside Android framework that communicates with
 * a wakeup server and receives wake up command.
 */
@VintfStability
interface IRemoteAccess {
    /**
     * Gets a unique device ID that could be recognized by wake up server.
     *
     * This device ID is provisioned during car production and is registered
     * with the wake up server.
     *
     * @return a unique device ID.
     */
    String getDeviceId();

    /**
     * Gets the name for the remote wakeup server.
     *
     * This name will be provided to remote task server during registration
     * and used by remote task server to find the remote wakeup server to
     * use for waking up the device. This name must be pre-negotiated between
     * the remote wakeup server/client and the remote task server/client and
     * must be unique. We recommend the format to be a human readable string
     * with reverse domain name notation (reverse-DNS), e.g.
     * "com.google.vehicle.wakeup".
     */
    String getWakeupServiceName();

    /**
     * Sets a callback to be called when a remote task is requested.
     *
     * @param callback A callback to be called when a remote task is requested.
     */
    void setRemoteTaskCallback(IRemoteTaskCallback callback);

    /**
     * Clears a previously set remote task callback.
     *
     * If no callback was set, this operation is no-op.
     */
    void clearRemoteTaskCallback();

    /**
     * Notifies whether AP is ready to receive remote tasks.
     *
     * <p>Wakeup client should store and use this state until a new call with a
     * different state arrives.
     *
     * <p>If {@code isReadyForRemoteTask} is true, the wakeup client may send
     * the task received from the server to AP immediately.
     *
     * <p>If {@code isReadyForRemoteTask} is false, it must store the received
     * remote tasks and wait until AP is ready to receive tasks. If it takes too
     * long for AP to become ready, the task must be reported to remote task
     * server as failed. Implementation must make sure no duplicate tasks are
     * delivered to AP.
     *
     * <p>If {@code isWakeupRequired} is true, it must try to wake up AP when a
     * remote task arrives or when there are pending requests.
     *
     * <p>If {@code isWakeupRequired} is false, it must not try to wake up AP.
     */
    void notifyApStateChange(in ApState state);
}
