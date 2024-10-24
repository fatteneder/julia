@eval Base function cpjit end
function Base.cpjit(ci::Core.CodeInstance, src::Core.CodeInfo)
    display(src)
    # display(isdefined(ci, :cpjit_mc))
    # display(ci.invoke)
    if isdefined(ci, :cpjit_mc) && ci.cpjit_mc === nothing
        println("ARE WE GETTING HERE?")
        @atomic :monotonic ci.cpjit_mc = 1.0
    end
    # @atomic ci.cpjit = 1.0
    # display(propertynames(ci))
    return Cint(1)
end
@ccall jl_use_cpjit_set(1::Cint)::Cvoid


@eval Base function cpjit_call end
function Base.cpjit_call(ci::Any, args::Any...)
    println("HELLO FROM cpjit_call")
    return 1.0
end
