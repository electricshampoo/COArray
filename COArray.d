import std.container;

void insert(T, string less="a < b")(ref SList!(T[]) list, T val){
    if (list.empty || list.front.length != 1){
        list.insert([val]);
    }
    else{
        list.insert([val]);
        merge_pass!(T,less)(list);
    }
}

void merge_pass(T, string less="a < b")(ref SList!(T[]) list){
    auto arr = list.removeAny;
    if (list.empty || (list.front.length != arr.length)){
        list.insert(arr);
    }
    else{
        auto arr2 = list.removeAny;
        list.insert(merge!(T,less)(arr,arr2));
        merge_pass(list);
    }
}

T[] merge(T, string less="a < b")(T[] a, T[] b) {
    import std.functional;              
    alias comp = binaryFun!less;
    T[] result;
    result.length = a.length + b.length;

    size_t i = 0;
    size_t j = 0;

    while (i < a.length && j < b.length){
        if (comp(b[j],a[i])){
            result[i+j] = b[j];
            j++;
        }
        else {
            result[i+j] = a[i];
            i++;
        }
    }

    if (i == a.length){
        result[i+j .. $] = b[j .. $];
    }
    else {
        result[i+j .. $] = a[i .. $];
    }

    return result;
}

unittest {
    auto a = [2,6,7];
    auto b = [1,2,3];
    assert(merge(a,b) == [1,2,2,3,6,7]);
}

unittest {
    auto a = [2];
    auto b = [1];
    assert(merge(a,b) == [1,2]);
}

unittest {
    auto a = [-3,1];
    auto b = [2];
    assert(merge(a,b) == [-3,1,2]);
}

unittest {
    auto a = [1];
    auto b = [1];
    assert(merge(a,b) == [1,1]);
}

unittest {
    int[] a = [1];
    int[] b = [];
    assert(merge(a,b) == [1]);
}

unittest {
    int[] a = [];
    int[] b = [1];
    assert(merge(a,b) == [1]);
}

unittest {
    int[] a = [];
    int[] b = [];
    assert(merge(a,b) == []);
}

bool contains(T)(SList!(T[]) list, T val){
    import std.range;

    if (list.empty){
        return false;
    }
    else if (assumeSorted(list.front).contains(val)){
        return true;
    }
    else { 
        list.removeFront;
        return contains(list, val);
    }
}

unittest{
    auto list = SList!(int[])();
    foreach(i; 0..1000)
        insert(list,i);
    assert(list.contains(99));
    assert(list.contains(0));
    assert(!list.contains(9999999));
}

