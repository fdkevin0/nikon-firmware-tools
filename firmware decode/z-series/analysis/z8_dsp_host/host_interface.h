/* Analytical layouts recovered from Z8 3.11 AArch64 host code.
 * Not Nikon headers or a complete DSP ABI. All addresses are numeric u64.
 * Unknown words must not be treated as unused or safe to modify.
 */
#include <stdint.h>
#include <stddef.h>

typedef struct {
    uint64_t data;
    uint64_t bytes;
} Z8NetworkView;

typedef struct {
    uint32_t configuration;           /* observed 0x00010800 */
    uint32_t unknown_04;
    Z8NetworkView vehicle;            /* +0x08: N1 */
    Z8NetworkView animal;             /* +0x18: N2 */
    Z8NetworkView other;              /* +0x28: zero in observed constructor */
    uint64_t workspace;              /* +0x38: alias(parameter block) + 0x80 */
    uint64_t workspace_bytes;        /* +0x40: observed 0x384d00 */
} Z8CdnnInitHostArgs;

typedef struct {
    uint32_t program_index;          /* 2 for neural inference */
    uint32_t unknown_04;
    uint32_t function_slot;          /* 3.11: init 29, animal 31, vehicle 32 */
    uint32_t unknown_0c;
    uint64_t input;
    uint64_t output;
    uint32_t queue_selector;         /* zero selects one queue; semantics partial */
    uint32_t unknown_24;
    uint64_t completion_callback;
    uint32_t result;
    uint32_t unknown_34;
} Z8HostDspRequestPrefix;

_Static_assert(sizeof(Z8CdnnInitHostArgs) == 0x48, "host initializer extent");
_Static_assert(offsetof(Z8CdnnInitHostArgs, animal) == 0x18, "animal descriptor");
_Static_assert(offsetof(Z8CdnnInitHostArgs, workspace) == 0x38, "workspace descriptor");
_Static_assert(offsetof(Z8HostDspRequestPrefix, function_slot) == 8, "function slot");
_Static_assert(offsetof(Z8HostDspRequestPrefix, completion_callback) == 0x28, "completion");
_Static_assert(offsetof(Z8HostDspRequestPrefix, result) == 0x30, "result");
