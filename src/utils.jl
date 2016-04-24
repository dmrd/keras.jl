using PyCall

"""
Converts an array to a Python array.  Given `revdims=true`, convert to row major ordering.
e.g. dims of (1, 2, 3, 4) on Julia side -> (4, 3, 2, 1) on Python side

.  Does not modify underlying memory.

Temporary utility function until next release of PyCall (as of 1.4.0). Adds `revdims` flag.
"""
function to_python_array{T<:PyCall.NPY_TYPES}(a::StridedArray{T}, revdims::Bool=false)
    @PyCall.npyinitialize
    size_a = revdims ? reverse(size(a)) : size(a)
    strides_a = revdims ? reverse(strides(a)) : strides(a)
    p = ccall(PyCall.npy_api[:PyArray_New], PyPtr,
              (PyPtr,Cint,Ptr{Int},Cint, Ptr{Int},Ptr{T}, Cint,Cint,PyPtr),
              PyCall.npy_api[:PyArray_Type],
              ndims(a), Int[size_a...], PyCall.npy_type(T),
              Int[strides_a...] * sizeof(eltype(a)), a, sizeof(eltype(a)),
              PyCall.NPY_ARRAY_ALIGNED | PyCall.NPY_ARRAY_WRITEABLE,
              C_NULL)
    return PyObject(p, a)
end

"""
Convert array to row major, C style arrays.
Does not modify memory during conversion
"""
function to_python_array(arr::AbstractArray)
    to_python_array(arr, size(arr)...)
end

"""
Convert array to row major, C style arrays.
Does not modify buffer during conversion

Specifically for bit arrays -> UInt8

Specify dimensions IN JULIA COORDINATES
Given Julia array with dims: (1, 2, 3)
Return Python array with dims: (3, 2, 1)
"""
function to_python_array(arr::AbstractArray, dims...)
    reshaped = reshape(arr, dims)
    rounded = round(UInt8, reshaped)
    to_python(rounded, true)
end
