run_analysis <- function(root,out) {
 d <- read.csv(file.path(root,"data/wine.csv"),check.names=FALSE); X <- as.matrix(d[,names(d)!="Class"])
 p <- prcomp(X,center=TRUE,scale.=TRUE); ratio <- p$sdev^2/sum(p$sdev^2); k <- which(cumsum(ratio)>=.9)[1]
 Z <- p$x[,1:k,drop=FALSE]%*%t(p$rotation[,1:k,drop=FALSE]); recovered <- sweep(sweep(Z,2,p$scale,"*"),2,p$center,"+")
 png(file.path(out,"pca.png"),1200,600); par(mfrow=c(1,2)); plot(cumsum(ratio),type="b",xlab="Components",ylab="Cumulative variance"); abline(h=.9,col=2); plot(p$x[,1:2],col=d$Class,pch=19,xlab="PC1",ylab="PC2"); legend("topright",legend=sort(unique(d$Class)),col=sort(unique(d$Class)),pch=19); dev.off()
 write.csv(data.frame(component=seq_along(ratio),explained=ratio,cumulative=cumsum(ratio)),file.path(out,"variance.csv"),row.names=FALSE)
 write.csv(recovered,file.path(out,"reconstructed.csv"),row.names=FALSE)
 A <- matrix(c(1,0,1,0,0,1,0,1),2,byrow=TRUE); s<-svd(A); inverse<-s$v%*%diag(1/s$d)%*%t(s$u); solution<-inverse%*%c(7,9)
 list(observations=nrow(X),features=ncol(X),components_90_percent=k,retained_variance=sum(ratio[1:k]),standardized_reconstruction_mse=mean((scale(X)-Z)^2),pseudoinverse_agreement=max(abs(inverse-MASS::ginv(A))),minimum_norm_solution=as.numeric(solution),solution_residual=max(abs(A%*%solution-c(7,9))))
}
