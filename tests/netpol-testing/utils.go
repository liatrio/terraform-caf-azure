package main

import (
	"fmt"

	corev1 "k8s.io/api/core/v1"
)

func PodName(pod *corev1.Pod) string {
	return fmt.Sprintf("[Pod %s/%s]", pod.Namespace, pod.Name)
}

func SvcName(svc *corev1.Service) string {
	return fmt.Sprintf("[Service %s/%s @ %s]", svc.Namespace, svc.Name, svc.Spec.ClusterIP)
}
