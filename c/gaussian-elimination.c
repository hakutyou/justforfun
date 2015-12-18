/*
 * Mail: 2994812129@qq.com
 * Date: 2015-12-18
*/


#include <stdio.h>
#include <math.h>
#include <malloc.h>
#include <windows.h>
//��˹��ȥ�������Է�����:
void Gauss(double *A,double *b,int n){//����Ax=b�Ľ⣬AΪn*n����
	int i,j,k,s,u,v,temp;
	double w, t,*x;//xΪ��
	x = (double *)malloc(n*sizeof(double));

	temp = 0;
	for(k=1;k<n;k++){//�жϵ�i�е����ֵ
		if(fabs(A[n*temp])<fabs(A[k*n]))
			temp = k;
	}
	if(temp!=0){//��i��������н���
		for(k=0;k<n;k++){
			t = A[k];
			A[k] = A[temp*n+k];
			A[temp*n+k] = t;
		}
		t = b[temp];
		b[temp] = b[0];
		b[0] = t;
	}

	for(i=0;i<n-1;i++){//�������Ϊ�����Ǿ���
		for(j=i+1;j<n;j++){//�����б任
			w = A[j*n+i]/A[i*n+i];
			for(k=i;k<n;k++)
				A[j*n+k] -= A[i*n+k]*w;
			b[j] -= b[i]*w; 		
		}
	}
	//���:
	x[n-1] = b[n-1]/A[(n-1)*n+n-1];
	for(k=n-2;k>=0;k--){
		x[k] = b[k];
		for(j=n-1;j>k;j--){
			x[k] = x[k]-A[k*n+j]*x[j];
		}
		x[k] = x[k]/A[k*n+k];
	}
	for(s=0;s<n;s++)
		printf("%lf\t",x[s]);
	
}
void main(){
	double *A ,*b;
	int n,i;
	printf("����Ľ�:");
	scanf("%d",&n);
	A = (double *)malloc(n*n*sizeof(double));
	b = (double *)malloc(n*sizeof(double));
	printf("A��ֵ:");
	for(i=0;i<n*n;i++)
		scanf("%lf",&A[i]);
	printf("b��ֵ:");
	for(i=0;i<n;i++)
		scanf("%lf",&b[i]);
	Gauss(A,b,n);
}
