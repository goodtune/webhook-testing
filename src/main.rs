use lambda_runtime::{handler_fn, Context, Error};

#[tokio::main]
async fn main() -> Result<(), Error> {
    let func = handler_fn(handler);
    lambda_runtime::run(func).await?;
    Ok(())
}

async fn handler(_: serde_json::Value, _: Context) -> Result<serde_json::Value, Error> {
    Ok(serde_json::json!({"message": "Hello from Lambda!"}))
}
