#### This was the eval-cpjit-into-Base approach
# const counter = Ref(0)
# @eval Base function cpjit end
# function Base.cpjit(ci::Core.CodeInstance, src::Core.CodeInfo)
#     # display(src)
#     # display(isdefined(ci, :cpjit_mc))
#     # display(ci.invoke)
#     if isdefined(ci, :cpjit_mc) && ci.cpjit_mc === nothing
#         # println("ARE WE GETTING HERE?")
#         @atomic :monotonic ci.cpjit_mc = "hello world nr $(counter[])!"
#         # println("AND HERE?")
#         counter[] += 1
#         @show ci.def.def.sig
#         # println("AND HEREEEEE?")
#     end
#     # @show cpjit.def
#     # @atomic ci.cpjit = 1.0
#     # display(propertynames(ci))
#     return Cint(1)
# end
# @ccall jl_use_cpjit_set(1::Cint)::Cvoid
#
#
# @eval Base function cpjit_call end
# function Base.cpjit_call(ci::Any, args::Any...)
#     # println("HELLO FROM cpjit_call")
#     # Core.println(Core.stdout, args[1])
#     # display(ci)
#     # display(args)
#     return 1.0
# end


module cpjit

@ccall jl_set_module_cpjit(@__MODULE__()::Any, false::Cint)::Cvoid

function cpjit_compile(ci::Core.CodeInstance, src::Core.CodeInfo)
    # display(src)
    # display(isdefined(ci, :cpjit_mc))
    # display(ci.invoke)
    if isdefined(ci, :cpjit_mc) && ci.cpjit_mc === nothing
        # println("ARE WE GETTING HERE?")
        @atomic :monotonic ci.cpjit_mc = "hello world nr $(counter[])!"
        # println("AND HERE?")
        counter[] += 1
        @show ci.def.def.sig
        # println("AND HEREEEEE?")
    end
    # @show cpjit.def
    # @atomic ci.cpjit = 1.0
    # display(propertynames(ci))
    return Cint(1)
end

function cpjit_call(ci::Any, args::Vector{Any})
    # println("HELLO FROM cpjit_call")
    # Core.println(Core.stdout, args[1])
    # display(ci)
    # display(args)
    return 1.0
end


function __init__()
    @ccall jl_set_cpjit_call(cpjit_call::Any)::Cvoid
    @ccall jl_set_cpjit_compile(cpjit_compile::Any)::Cvoid
    @ccall jl_cpjit_enable(true::Cint)::Cvoid
end

end
