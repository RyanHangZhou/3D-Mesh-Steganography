# Distortion Design for Secure Adaptive 3D Mesh Steganography
Created by [Hang Zhou](http://home.ustc.edu.cn/~zh2991/), [Kejiang Chen](http://home.ustc.edu.cn/~chenkj/), [Weiming Zhang](http://staff.ustc.edu.cn/~zhangwm/index.html), Yuanzhi Yao, [Nenghai Yu](http://staff.ustc.edu.cn/~ynh/).

Introduction
--
This work is published on Transactions on Multimedia (TMM), 2018. 

We propose a novel technique for steganography on 3D meshes so as to resist steganalysis. The majority of existing methods modulate vertex coordinates to embed messages in a non-adaptive way. We take account of complexity of local regions as joint distortion of a triple unit (vertice) and coding method such as Syndrome Trellis Codes (STCs) to adaptively embed messages, which owns stronger security with respect to existing steganalysis. Key to the distortion is a novel formulation of adaptive steganography, which relies on some effective steganalytic features such as variation of vertex normal. We provide quantitative and qualitative comparison of our method with several baselines against steganalytic features LFS64, LFS76 and ensemble classifiers and show that it outperforms the current state of the art. Meanwhile, we proposed an attacking method on steganography proposed by Chao et al. (2009) with a high detection rate.

Citation
--
If you find our work useful in your research, please consider citing:

    @article{zhou2018distortion,
     title={Distortion Design for Secure Adaptive 3-D Mesh Steganography},
     author={Zhou, Hang and Chen, Kejiang and Zhang, Weiming and Yao, Yuanzhi and Yu, Nenghai},
     journal={IEEE Transactions on Multimedia},
     volume={21},
     number={6},
     pages={1384--1398},
     year={2018},
     publisher={IEEE}
    }



Usage
--


    Download "toolbox_graph", a public toolbox for 3D mesh processing;
    Put source 3D meshes in the "data/source" directory;
    Start from main.m.

License
--
