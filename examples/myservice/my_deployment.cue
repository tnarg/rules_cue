package myservice

import (
	appsv1 "k8s.io/api/apps/v1"
)

#MyDeployment: appsv1.#Deployment & {
	#Replicas: int

	apiVersion: "extensions/v1beta1"
	kind:       "Deployment"
	metadata: {
		name:      "myservice"
		namespace: "myservice"
		labels: app: "myservice"
	}
	spec: {
		replicas: #Replicas
		strategy: type: "Recreate"
		selector: matchLabels: app: "myservice"
		template: {
			metadata: {
				labels: app: "myservice"
			}
			spec: {
				volumes: [{
					name: "config"
					configMap: name: "myservice"
				}, {
					name: "credentials"
					secret: secretName: "credentials"
				}]
				containers: [{
					name:            "myservice"
					image:           "myorg/myservice:latest"
					imagePullPolicy: "Always"
					volumeMounts: [{
						name:      "config"
						mountPath: "/etc/myservice/config.yaml"
						subPath:   "config.yaml"
					}, {
						name:      "credentials"
						mountPath: "/etc/myservice/secure"
					}]
					lifecycle: postStart: exec: command: [
						"/busybox/sh",
						"-c",
						"chmod 400 /etc/myservice/secure/*",
					]
				}]
			}
		}
	}
}
