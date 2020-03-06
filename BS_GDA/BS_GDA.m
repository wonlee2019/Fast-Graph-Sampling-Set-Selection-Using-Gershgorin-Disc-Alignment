function [ selected_pebbles_out,left ] = BS_GDA( adj_list,K,mu,epsilon,is_shuffle )
% adj_list is a adjcency list structure generated by sparse_neighbours_preparation function 
% K is sampling budget
% mu is the parameter for graph Laplacian based signal reconstruction (try 0.01 for other arbitrary reconstruction methods)
% epsilon is the numerical precision for binary search (1e-5 by default)
% is_shuffle decides whether to shuffle nodes before greedy sampling (True by default) 

if nargin<5, is_shuffle=true; end
if nargin<4, epsilon=1e-5; end
if nargin<3, mu=0.01; end

d=adj_list.d;
neis=adj_list.neis;
neis_n=adj_list.neis_n;
neis_w=adj_list.neis_w;

n=length(d);

left=0;
right=1;
thres=(right+left)/2;

flag=false;

p_hops=12;

if is_shuffle
    pebbles_order=randperm(n);
else
    pebbles_order=1:n;
end

%%
while abs(right-left)>epsilon 

    [ ~,vf ] = greedy_sampling( d,neis,neis_n,neis_w,n,mu,thres,K,pebbles_order,p_hops );  
    
    if ~vf
        right=thres;
        thres=(right+left)/2;
    else
        left=thres;
        thres=(right+left)/2;   
        flag=true;
    end
    
    if right<left
        error('binary search error!');
    end
end


[ selected_pebbles ] = greedy_sampling( d,neis,neis_n,neis_w,n,mu,right,K,pebbles_order,p_hops );
if ~flag
    fprintf('Warning: epsilon is set too large, sub-optimal lower bound is output.\n');
end

tmp=1:n;
selected_pebbles_out=tmp(selected_pebbles>0);

end







