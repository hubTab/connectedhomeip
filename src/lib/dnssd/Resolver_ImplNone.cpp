/*
 *
 *    Copyright (c) 2021 Project CHIP Authors
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

#include "Resolver.h"

#include <lib/support/logging/CHIPLogging.h>

namespace chip {
namespace Dnssd {
namespace {

class NoneResolver : public Resolver
{
public:
    CHIP_ERROR Init(chip::Inet::InetLayer *) override { return CHIP_NO_ERROR; }
    void Shutdown() override {}
    void SetResolverDelegate(ResolverDelegate *) override {}

    CHIP_ERROR ResolveNodeId(const PeerId & peerId, Inet::IPAddressType type) override
    {
        ChipLogError(Discovery, "Failed to resolve node ID: dnssd resolving not available");
        return CHIP_ERROR_NOT_IMPLEMENTED;
    }
    CHIP_ERROR FindCommissionableNodes(DiscoveryFilter filter = DiscoveryFilter()) override { return CHIP_ERROR_NOT_IMPLEMENTED; }
    CHIP_ERROR FindCommissioners(DiscoveryFilter filter = DiscoveryFilter()) override { return CHIP_ERROR_NOT_IMPLEMENTED; }
};

NoneResolver gResolver;

} // namespace

Resolver & chip::Dnssd::Resolver::Instance()
{
    return gResolver;
}
} // namespace Dnssd
} // namespace chip
