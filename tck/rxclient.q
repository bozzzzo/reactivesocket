quark 1.0;
use rxlib.q;

import quark.concurrent;
import quark.logging;
import rxlib;

class Printer extends Requester {

    void onResponse(Response response) {
        print(response.toString());
    }

    void onError(Error error) {
        print("ERROR: " + error.toString());
    }

}

void spam(RequestClient client, Requester requester, int count) {
    int idx = 0;
    while (idx < 10) {
        client.request(new Request(), requester);
        idx = idx + 1;
    }
}

void main(List<String> args) {
    Config config = logging.makeConfig();
    config.setAppender(logging.stdout());
    // Set this to debug for a full trace of all network interactions.
    config.setLevel("info");
    config.configure();
    Runtime runtime = Context.runtime();

    Printer printer = new Printer();

    RequestClient client = new SimpleRequestClient();
    runtime.open(args[1] + "/request", new RXHandler(client));
    spam(client, printer, 10);

    client = new LeasedRequestClient();
    runtime.open(args[1] + "/lease/request", new RXHandler(client));
    spam(client, printer, 10);
}
