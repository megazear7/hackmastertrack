/* Section 1: Definitions
 *
 * Hack Entity:
 *      A record in solr. Contains some basic information such as
 *      title, description and categories. A Hack Entity does not refer
 *      to the complete information that exists in hack api, but just
 *      that information that gets returned by solr.
 *
 * Hack Component:
 *      A React Component that implements a hack entity usually by
 *      using the Hack API to get more data about the thing and
 *      usually providing one or more actions the user can take.
 *      The Hack Component has a "Card" view that shows up in the
 *      list of search results which is returned in the components
 *      render method. It may optionally have a "Details" view that
 *      shows up when the card is opened and is returned by the
 *      open() method. This latter method must return an array of Cells.
 *
 * Hack API:
 *      The API that provides all of the async data and functionality of
 *      Hackmaster website for use withen Hack Components.
 *
 * Hack Solr:
 *      The Solr server that returns a list of relevant Hack Entities
 *      if it is provided with a search term. In this way the user
 *      can fidn the functionality he needs by simply typing into the
 *      search box.
 * */

/* Section 2: Hack Components
 * These components are react components representing hackmastertrack entities. */

class Overview extends React.Component {
    constructor(props) {
        super(props);

        this.open = this.open.bind(this);
    }

    open() {
        var self = this;

        HackAPI.characters
        .find(104, function(character) {
            self.props.forward(
                <Cell desktop="12">
                    <Grid nested={true}>
                        <Cell desktop="12" tablet="8" phone="4">
                            <H1>{character.race + " " + character.character_class}</H1>
                        </Cell>
                        <Cell desktop="4" tablet="4" phone="2">
                            <div>Strength: {character.strength}</div>
                            <div>Dexterity: {character.dexterity}</div>
                            <div>Constitution: {character.constitution}</div>
                            <div>Intelligence: {character.intelligence}</div>
                            <div>Wisdom: {character.wisdom}</div>
                            <div>Charisma: {character.charisma}</div>
                            <div>Looks: {character.looks}</div>
                        </Cell>
                        <Cell desktop="4" tablet="4" phone="2">
                            <div>Silver: {character.silver}</div>
                            <div>Health: {character.health}</div>
                            <div>EXP: {character.experience}</div>
                        </Cell>
                    </Grid>
                </Cell>);
        });
    }

    render() {
        return (
            <Cell desktop="3" tablet="4" phone="4">
                <Card>
                    <CardTitle>
                        {this.props.hackEntity.title}
                    </CardTitle>
                    <CardText>
                        {this.props.hackEntity.description}
                    </CardText>
                    <CardActions>
                        <Button action={this.open}>
                            Open
                        </Button>
                    </CardActions>
                </Card>
            </Cell>
        );
    }
}

/* This is a generic Hack Component that just displays the title, description
 * and category of the Hack Entity. This will be used if no other Hack Component
 * is found to match the Hack Entity. */
class Unimplemented extends React.Component {
    constructor(props) {
        super(props);

        this.open = this.open.bind(this);
    }

    open() {
        this.props.forward(
            <Cell desktop="12">
                <Grid nested={true}>
                    <Cell desktop="9" key="title">
                        <H1>{this.props.hackEntity.title}</H1>
                    </Cell>
                    <Cell desktop="3" key="description">
                        <H5>{this.props.hackEntity.category1}</H5>
                    </Cell>
                </Grid>
            </Cell>);
    }

    render() {
        return (
            <Cell desktop="3" tablet="4" phone="2">
                <Card>
                    <CardTitle>
                        {this.props.hackEntity.title}
                    </CardTitle>
                    <CardText>
                        {this.props.hackEntity.description}
                    </CardText>
                    <CardActions>
                        <Button action={this.open}>
                            Open
                        </Button>
                    </CardActions>
                </Card>
            </Cell>
        );
    }
}

/* Section 3: Hack Entity to Hack Component Mapping
 * This function maps a Hack Entity to the Hack Component that implements it */

function createHackComponent(hackEntity, forward) {
    var key = "";

    // TODO set hackid's for everything in solr and then get rid of this check.
    // and just use the hackid instead of falling back to the path.
    if (hackEntity.hackid) {
        key = hackEntity.hackid;
    } else if (hackEntity.path) {
        key = hackEntity.path;
    }

    if (hackEntity.category1 === "overview") {
        return hackComponent = (
            <Overview hackEntity={hackEntity}
                      key={key}
                      forward={forward} />);
    } else {
        return hackComponent = (
            <Unimplemented hackEntity={hackEntity}
                           key={key}
                           forward={forward} />);
    }
}

/* Section 4: MDL Components
 * These components are React.Components representing MDL Componentes. */

class CardTitle extends React.Component {
    render() {
        return (
            <div className="mdl-card__title mdl-card--expand">
                <h2 className="mdl-card__title-text">
                    {this.props.children}
                </h2>
            </div>
        );
    }
}

class CardText extends React.Component {
    render() {
        return (
            <div className="mdl-card__supporting-text">
                {this.props.children}
            </div>
        );
    }
}

class CardActions extends React.Component {
    render() {
        return (
            <div className="mdl-card__actions mdl-card--border">
                {this.props.children}
            </div>
        );
    }
}

class H1 extends React.Component {
    render() {
        return (
            <h1 className="mdl-typography--display-1">
                {this.props.children}
            </h1>
        );
    }
}

class H2 extends React.Component {
    render() {
        return (
            <h1 className="mdl-typography--display-2">
                {this.props.children}
            </h1>
        );
    }
}

class H3 extends React.Component {
    render() {
        return (
            <h1 className="mdl-typography--display-3">
                {this.props.children}
            </h1>
        );
    }
}

class H4 extends React.Component {
    render() {
        return (
            <h1 className="mdl-typography--display-4">
                {this.props.children}
            </h1>
        );
    }
}

class H5 extends React.Component {
    render() {
        return (
            <h1 className="mdl-typography--headline">
                {this.props.children}
            </h1>
        );
    }
}

class H6 extends React.Component {
    render() {
        return (
            <h1 className="mdl-typography--title">
                {this.props.children}
            </h1>
        );
    }
}

class Button extends React.Component {
    render() {
        return (
            <a onClick={this.props.action} className="mdl-button mdl-button--colored">
                {this.props.children}
            </a>
        );
    }
}

class BackButton extends React.Component {
    render() {
        return (
            <button className="mdl-button mdl-js-button mdl-button--icon back">
                <i className="material-icons" onClick={this.props.action}>arrow_back</i>
            </button>
        );
    }
}

class Cell extends React.Component {
    cellClass() {
        var cellClasses = ["mdl-cell"];

        if (this.props.desktop === 0) {
            cellClasses.push("mdl-cell--hide-desktop");
        } else if (this.props.desktop > 0) {
            cellClasses.push("mdl-cell--"+this.props.desktop+"-col-desktop");
        }

        if (this.props.tablet === 0) {
            cellClasses.push("mdl-cell--hide-tablet");
        } else if (this.props.tablet > 0) {
            cellClasses.push("mdl-cell--"+this.props.tablet+"-col-tablet");
        }

        if (this.props.phone === 0) {
            cellClasses.push("mdl-cell--hide-phone");
        } else if (this.props.phone > 0) {
            cellClasses.push("mdl-cell--"+this.props.phone+"-col-phone");
        }

        return cellClasses.join(" ");
    }

    render() {
        return (
            <div className={this.cellClass()}>
                {this.props.children}
            </div>
        );
    }
}

class Card extends React.Component {
    render() {
        return (
            <div className="mdl-card hack-full-card mdl-shadow--2dp">
                {this.props.children}
            </div>
        );
    }
}

class Search extends React.Component {
    constructor(props) {
        super(props);

        this.state = {terms: ''};

        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
    }

    componentDidMount() {
        componentHandler.upgradeElement(this.textInput);
    }

    handleChange(e) {
        this.setState({terms: e.target.value});
    }

    handleSubmit(e) {
        e.preventDefault();
        var self = this;

        HackSolr.search(this.state.terms, { owners: ["2"], groups: ["everyone"] }, function(hackEntities) {
            var searchResultCards = [];

            $.each(hackEntities, function(index, hackEntity) {
                searchResultCards.push(createHackComponent(hackEntity, self.props.forward));
            });

            var searchResults = (
                <Cell desktop="12">
                    <Grid nested={true}>
                        {searchResultCards}
                    </Grid>
                </Cell>
            );

            self.props.forward(searchResults);
        });
    }

    render() {
        return (
            <form onSubmit={this.handleSubmit}>
                <div className="mdl-textfield mdl-js-textfield" ref={(input) => { this.textInput = input; }}>
                    <input className="mdl-textfield__input" type="text" id="hack-search" onChange={this.handleChange} />
                    <label className="mdl-textfield__label" htmlFor="hack-search">Search for anything...</label>
                </div>
            </form>
        )
    }
}

class Grid extends React.Component {
    render() {
        var className = "mdl-grid";

        if (this.props.nested === true) {
            className += " mdl-grid--nesting";
        }

        return (
            <div className={className}>
                {this.props.children}
            </div>
        );
    }
}

class Content extends React.Component {
    constructor(props) {
        super(props);

        this.backToStart = this.backToStart.bind(this);
        this.forward = this.forward.bind(this);
        this.backward = this.backward.bind(this);
        this.cells = this.cells.bind(this);

        this.state = { };

        this.state.startCards =  (
            <Cell desktop="12">
                <Grid nested={true}>
                    {this.props.startHackEntities.map((hackEntity) =>
                         createHackComponent(hackEntity, this.forward))}
                </Grid>
            </Cell>
        );

        this.state.history = [ ];
        this.state.history.push(this.state.startCards);
    }

    backToStart() {
        this.forward(this.state.startCards);
    }

    forward(cells) {
        if (this.state.history.length < 40) {
            this.state.history.push(cells);
            this.forceUpdate();
        } else {
            this.setState(function(prevState, props) {
                var newHistory = prevState.history.slice(prevState.history.length / 2);
                newHistory.push(cells);
                return { history: newHistory };
            });
        }
    }

    backward() {
        this.state.history.pop();
        this.forceUpdate();
    }

    cells() {
        return this.state.history[this.state.history.length-1];
    }

    render() {
        return(
            <main className="mdl-layout__content">
                <Grid>
                    <Cell desktop="2" tablet="2" phone="0">
                        {this.state.history.length > 1 && <BackButton action={this.backward} />}
                    </Cell>
                    <Cell desktop="2" tablet="0" phone="0" />
                    <Cell desktop="4" tablet="4" phone="4">
                        <Search forward={this.forward} />
                    </Cell>
                    <Cell desktop="4" tablet="2" phone="0" />
                    {this.cells()}
                </Grid>
            </main>
        );
    }
}

class IconLink extends React.Component {
    render() {
        return (
          <a className="mdl-navigation__link" href={this.props.href}>
            <i className="material-icons">{this.props.icon}</i>
            Character
          </a>
        );
    }
}

class Link extends React.Component {
    constructor(props) {
        super(props);

        this.onClickEvent = this.onClickEvent.bind(this);
    }

    onClickEvent(e) {
        if (this.props.action) {
            e.preventDefault();
            this.props.action(this.props);
        }
    }

    render() {
        return (
            <span className={"mdl-layout__link" + (this.props.isCurrent ? " mdl-navigation__link--current" : "")}>
                <a className="mdl-navigation__link"
                   href={this.props.href}
                   onClick={this.onClickEvent}>
                    {this.props.children}
                </a>
            </span>
        );
    }
}

class Drawer extends React.Component {
    constructor(props) {
        super(props);

        this.drawerNavChange = this.drawerNavChange.bind(this);
    }

    drawerNavChange(linkProps) {
        var self = this;

        HackAPI.characters
        .find(linkProps.characterId, function(newCurrentCharacter) {
            self.props.onNavChange(newCurrentCharacter);
        });
    }

    render() {
        var self = this;

        var links = [];
        if (self.props.characters){
            links = self.props.characters.map(function(character) {
                return (
                    <Link key={character.id}
                          characterId={character.id}
                          action={self.drawerNavChange}
                          isCurrent={self.props.currentCharacter && character.id === self.props.currentCharacter.id}>
                        {character.name}
                    </Link>
                )
            });
        }

        return (
            <div className="mdl-layout__drawer">
                <span className="mdl-layout__title">{this.props.title}</span>
                <nav className="mdl-navigation">
                    {links}
                    <IconLink href="/characters/step1" icon="add" />
                </nav>
            </div>
        );
    }
}


class Header extends React.Component {
    render() {
        return (
          <header className="mdl-layout__header">
            <div className="mdl-layout__header-row">
              <span className="mdl-layout__title">
                {this.props.character && this.props.character.name}
              </span>
              <div className="mdl-layout-spacer"></div>
              <Link href="/">
                Classic Version
              </Link>
            </div>
          </header>
        )
    }
}

class Layout extends React.Component {
    constructor(props) {
        super(props);

        this.drawerNavChange = this.drawerNavChange.bind(this);

        this.state = { };
    }

    componentDidMount() {
        var self = this;
        HackAPI.characters()
        .first(function(currentCharacter) {
            self.setState({currentCharacter: currentCharacter});
        })
        .all(function(characters) {
            self.setState({characters: characters});
        });
    }

    drawerNavChange(character) {
        this.setState({currentCharacter: character});
    }

    render() {
        return (
            <div className="mdl-layout mdl-js-layout mdl-layout--fixed-drawer mdl-layout--fixed-header mdl-color-text--grey-600 main-layout">
                <Header character={this.state.currentCharacter} />
                <Drawer title={this.props.title}
                        onNavChange={this.drawerNavChange}
                        currentCharacter={this.state.currentCharacter}
                        characters={this.state.characters} />
                <Content startHackEntities={this.props.startHackEntities} />
            </div>
        );
    }
}

$(document).ready(function() {
    var startHackEntities = [
        {
            name: "overview",
            hackid: "overview",
            category1: "overview",
            title: "Overview",
            description: "Your characters race, class, ability scores, money, health and experience.",
        },
        {
            name: "combat",
            hackid: "combat",
            category1: "combat",
            title: "Combat",
            description: "Your combat values and equiped weapon / armor sets.",
        },
        {
            name: "spells",
            hackid: "spells",
            category1: "spells",
            title: "Spells",
            description: "Your spells. Lorem ipsum...",
        },
        {
            name: "equipment",
            hackid: "equipment",
            category1: "equipment",
            title: "Equipment",
            description: "Your characters weapons, armor and inventory.",
        },
        {
            name: "proficiencies",
            hackid: "proficiencies",
            category1: "proficiencies",
            title: "Proficiencies",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "specializations",
            hackid: "specializations",
            category1: "specializations",
            title: "Specializations",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "talents",
            hackid: "talents",
            category1: "talents",
            title: "Talents",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "skills",
            hackid: "skills",
            category1: "skills",
            title: "Skills",
            description: "Your talents, proficiencies, skills, and .",
        }
    ];

    var layout = <Layout startHackEntities={startHackEntities} title="Hacktrack" />;
    ReactDOM.render(layout, document.getElementById('react-root'));
});
