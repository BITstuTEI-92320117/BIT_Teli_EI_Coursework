function Zin = MoM_Zin(I, N, l, flag)
%% 计算输入阻抗
Zin = 1/(I((N+1)/2));
if flag == 1
    fname = sprintf('输入阻抗(N=%d,l=%.3f).mat',N,l);
    save(fname,'Zin');
end
end