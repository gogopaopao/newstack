+++
title = 'Pytorch学习'
date = 2026-04-03T23:26:51+08:00
categories = ["深度学习","pytorch"]
+++

## 1. Dataset类学习：告诉程序数据集在什么地方和索引(牌库)

### 1.1 python 中的继承：

```py
class PHMDataset_Sequential(Dataset):
```

#### 1.1.1继承方式与c++的继承不一样

- **C++：区分继承权限。** C++ 在继承时必须指定权限（`public`、`protected`、`private`），这决定了父类成员在子类中的可见性。
- **Python：默认全盘接收。** Python 没有继承权限的概念，默认就是“公开继承”，子类直接继承父类的所有属性和方法。

```cpp
// C++: 明确指定 public 继承
class Base { ... };
class Derived : public Base { ... }; 
```

```py
# Python: 括号一括，直接继承
class Base: pass
class Derived(Base): pass
```

####  1.1.2 方法重写与多态（虚函数）

- **C++：默认静态绑定，需要显式声明 `virtual`。**
- **Python：天生多态，所有方法都是“虚函数”。** Python 是动态类型语言（鸭子类型），只要子类定义了和父类同名的方法，就会自动覆盖（重写）父类的方法。所有的调用都是在运行时决定的（晚绑定）。

#### 1.1.3双下划线函数的意义

```py
class PHMDataset_Sequential(Dataset):
    """
    功能：构建针对 PHM IEEE 2012 数据集的时序数据集 (PyTorch Dataset)。
          它会将数据打包成具有一定时间步长 (sequence length) 的序列，用于 LSTM 的输入。
    """
    def __init__(self, dataset_id=0, indices=[], seq_len=5):
        """
        参数：
            dataset_id (int): 对应全局 DATA 列表中的数据集索引。
            indices (list): 需要包含在当前数据集中的样本索引列表（用于划分训练/验证集）。
            seq_len (int): 序列长度。即模型一次性读取连续的 seq_len 个样本作为输入 (x)，
                           并以该序列最后一个时间步的失效概率作为标签 (y)。
        """
        self.dataset_id = dataset_id
        self.indices = indices
        self.seq_len = seq_len

    def __len__(self):
        # 返回当前数据集包含的序列总数
        return len(self.indices)

    def __getitem__(self, i):
        # 根据索引 i 获取具体的序列数据和对应的标签
        sample_id = self.indices[i]
        sample = {
            'x': torch.from_numpy(DATA[self.dataset_id]['x'][sample_id:sample_id + self.seq_len]),
            'y': torch.from_numpy(DATA[self.dataset_id]['y'][sample_id + self.seq_len - 1])
        }
        return sample
```

```py
# 假设已经准备好了 indices 列表
train_dataset = PHMDataset_Sequential(dataset_id=dataset_id, indices=train_indices, seq_len=SEQ_LEN)
```

| **方法**      | **官方名称** | **触发时机**                 | **C++ 对应概念**                                           | **笔记**                                                     |
| ------------- | ------------ | :--------------------------- | ---------------------------------------------------------- | ------------------------------------------------------------ |
| `__init__`    | 构造函数     | **实例化对象时**自动执行一次 | `PHMDataset_Sequential()` 构造函数，填入参数`dataset_id`等 | 用于接收原始数据、索引映射、参数配置等。                     |
| `__len__`     | 长度方法     | 调用 `len(obj)` 时触发       | `length(train_dataset)`                                    | 返回当前数据集可用的**总样本数**。                           |
| `__getitem__` | 索引获取     | 使用 **`obj[i]`** 取值时触发 | `train_dataset[]` 运算==符重载==                           | **最核心**。负责根据索引 `i` 从原始数据中切片、转换 Tensor 并返回单条数据。 |

## 2. DataLoader类学习：取数据(取多少怎么取) 加载数据(手是神经网络，抽牌)

```py
# 封装为 DataLoader
train_dataloaders.append(DataLoader(train_dataset, batch_size=train_batch_size, shuffle=True, num_workers=0))
val_dataloaders.append(DataLoader(val_dataset, batch_size=val_batch_size, shuffle=False, num_workers=0))
```

**Parameters: **只需设置少量参数，大部分都是用的默认值

- **dataset** ([*Dataset*](https://docs.pytorch.org/docs/stable/data.html#torch.utils.data.Dataset)) – dataset from which to load the data.
- **batch_size** ([*int*](https://docs.python.org/3/library/functions.html#int)*,* *optional*) – how many samples per batch to load (default: `1`).  每次取几个数据集

- **shuffle** ([*bool*](https://docs.python.org/3/library/functions.html#bool)*,* *optional*) – set to `True` to have the data **reshuffled(重新洗牌)** at every epoch (default: `False`).
- **num_workers** ([*int*](https://docs.python.org/3/library/functions.html#int)*,* *optional*) – how many subprocesses to use for data loading. `0` means that the data will be loaded in the main process. (default: `0`)  Windows 中大于1容易出现问题

## 3. 网络搭建：nn.Module学习(所有神经网络模块的基础类)

基础搭建：两个函数都要有，init和forward

```py
class Model(nn.Module):
    def __init__(self) -> None:
        super().__init__()
        self.conv1 = nn.Conv2d(1, 20, 5)
        self.conv2 = nn.Conv2d(20, 20, 5)
# 前向传递
Define the computation performed at every call.
Should be overridden by all subclasses.
    def forward(self, x):
        x = F.relu(self.conv1(x))
        return F.relu(self.conv2(x))
```





**预测时间 (FPT)**：在机器运行初期计算峰度（kurtosis）的均值和标准差，当连续两次的峰度值满足 $|k_{i-1}-\mu|>2\sigma$ 时，将该时刻判定为退化起点（FPT） 

**构建 RUL 标签**：仅对 FPT 之后的数据进行寿命预测，根据公式计算剩余使用寿命百分比作为标签，例如起始点为 100%，寿命终点为 0% 。

**短时傅里叶变换 (STFT)**：对 FPT 之后的信号应用 STFT 转换为时频域信息，窗口选择 20ms 的 Hamming 窗，步长为 10ms 。
