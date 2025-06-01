SERVICE_ARN="arn:aws:apprunner:eu-central-1:310154938301:service/polonium-service/67928d4cc0df4bdabd0aaa9e20de2636"

echo "Resuming App Runner service..."
aws apprunner resume-service --service-arn "$SERVICE_ARN"
