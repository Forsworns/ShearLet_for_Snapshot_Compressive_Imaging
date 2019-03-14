% �𿪶�k����άͼƬ�ֱ������ͶӰ����������ڻ������������
function theta = estimate_product(L,N,frames,Phi,psi,theta,y)    
    for k = 1:frames
        x = Phi(:,:,k)*(psi).';
        theta((k-1)*N+1:k*N) = theta((k-1)*N+1:k*N) + (y'*x).'/sqrt(L);
    end
end